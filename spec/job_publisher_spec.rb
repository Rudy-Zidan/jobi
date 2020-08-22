require 'jobs/dummy_job'

module Jobi
  RSpec.describe Job do
    let(:uuid_regex) do
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    end

    before :each do
      config = Jobi::Config::Rabbitmq.new
      allow(Bunny).to receive(:new).and_return(BunnyMock.new(config.to_h))
      @message_id = Jobs::DummyJob.run(first: 1, second: 2)
    end

    context 'run' do
      it 'should have a message with same job class' do
        message = Jobs::DummyJob.instance_variable_get(:@message)
        expect(message.job_class).to be(Jobs::DummyJob)
      end

      it 'should return a valid message id of type UUID' do
        result = uuid_regex.match?(@message_id)

        expect(result).to be_truthy
      end

      it 'should publish the job to the queue' do
        queue = Jobs::DummyJob.instance_variable_get(:@queue)
        expect(queue.message_count).to be(1)
      end

      it 'should publish a persistable message to the queue' do
        queue = Jobs::DummyJob.instance_variable_get(:@queue)
        delivery_info, metadata, payload = queue.pop
        expect(metadata[:persistent]).to be_truthy
      end
    end

    after do
      Jobs::DummyJob.instance_variable_get(:@queue).delete
      GC.start
    end
  end
end