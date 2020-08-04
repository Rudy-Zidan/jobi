require 'jobs/dummy_job'

module Jobi
  RSpec.describe Runner do
    let(:payload) do
      args = { first: 1, second: 2 }
      message = Jobi::Message.new(job_class: Jobs::DummyJob, args: args)
      Marshal.dump(message)
    end

    let(:runner) { Jobi::Runner.new(payload: payload) }

    context 'initialize' do
      it 'should have a instance variable called message' do
        expect(runner.instance_variable_get(:@message)).to be_truthy
      end
    end

    context 'run' do
      it 'should run the job class' do
        expect(runner.run).to be_truthy
      end
    end
  end
end