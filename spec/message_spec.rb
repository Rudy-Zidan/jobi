module Jobi
  RSpec.describe Message do
    let(:dummy_class) do
      Class.new
    end

    let(:uuid_regex) do
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    end

    let(:message) do
      Jobi::Message.new(job_class: dummy_class, args: {})
    end

    context 'initialize' do
      it 'should have a recent started_at' do
        expect(Time.now.to_f - message.started_at).to be < 1.0
      end

      it 'should have a job class type of class' do
        expect(message.job_class.class).to be(dummy_class.class)
      end

      it 'should have a valid id of type UUID' do
        result = uuid_regex.match?(message.id)

        expect(result).to be_truthy
      end

      it 'should have a nil after_run method' do
        expect(message.after_run).to be(nil)
      end
    end
  end
end