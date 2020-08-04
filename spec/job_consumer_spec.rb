require 'jobs/dummy_job'

module Jobi
  RSpec.describe Job do
    before do
      config = Jobi::Config::Rabbitmq.new
      allow(Bunny).to receive(:new).and_return(BunnyMock.new(config.to_h))

      Jobi.configure do |config|
        config.act_as_consumer = true
        config.jobs = ['Jobs::DummyJob']
      end

      Jobs::DummyJob.run(first: 1, second: 2)
    end

    context 'consume_messages' do
      before do
        @consumers = Jobs::DummyJob.instance_variable_get(:@consumer_threads)
      end
      it 'should have 2 consumers' do
        expect(@consumers.size).to eq(2)
      end

      after do
        @consumers.each(&:exit)
        Jobs::DummyJob.instance_variable_get(:@queue).delete
        GC.start
      end
    end
  end
end