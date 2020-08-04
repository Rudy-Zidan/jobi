require 'logger'
require 'jobs/dummy_job'

RSpec.describe Jobi do
  it 'has a version number' do
    expect(Jobi::VERSION).not_to be nil
  end

  context 'default configurations' do
    before :each do
      allow(Jobi).to receive(:configuration).and_return(Jobi::Configuration.new)
    end

    it 'should have a valid configuration' do
      expect(Jobi.configuration.class).to be(Jobi::Configuration)
    end

    it 'should have a valid client equals to rabbitmq' do
      expect(Jobi.configuration.client).to be(:rabbitmq)
    end

    it 'should have a valid log level equals to info' do
      expect(Jobi.configuration.log_level).to be(Logger::INFO)
    end

    it 'should have a valid logger' do
      expect(Jobi.logger.class).to be(Logger)
    end

    it 'should act as publisher' do
      expect(Jobi.publisher?).to be_truthy
    end

    it 'should act as consumer' do
      expect(Jobi.consumer?).to be_truthy
    end

    it 'should have an empty jobs' do
      expect(Jobi.configuration.jobs.count).to be(0)
    end

    it 'should return a valid rabbitmq session' do
      expect(Jobi.session.class).to be(Jobi::Clients::Rabbitmq)
    end
  end

  context 'custom configurations' do
    before :each do
      Jobi.configure do |config|
        config.rabbitmq
        config.act_as_publisher = true
        config.act_as_consumer = false
        config.log_level = :debug
        config.jobs = ['Jobs::DummyJob']
      end
    end

    it 'should have a valid configuration' do
      expect(Jobi.configuration.class).to be(Jobi::Configuration)
    end

    it 'should have a valid client equals to rabbitmq' do
      expect(Jobi.configuration.client).to be(:rabbitmq)
    end

    it 'should have a valid log level equals to info' do
      expect(Jobi.configuration.log_level).to be(Logger::DEBUG)
    end

    it 'should have a valid logger' do
      expect(Jobi.logger.class).to be(Logger)
    end

    it 'should act as publisher' do
      expect(Jobi.publisher?).to be_truthy
    end

    it 'should not act as consumer' do
      expect(Jobi.consumer?).to be_falsy
    end

    it 'should have an empty jobs' do
      expect(Jobi.configuration.jobs.count).to be(1)
    end

    it 'should return a valid rabbitmq session' do
      expect(Jobi.session.class).to be(Jobi::Clients::Rabbitmq)
    end
  end
end
