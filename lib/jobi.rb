require 'jobi/version'
require 'logger'
require 'jobi/utils'
require 'jobi/job'
require 'jobi/configuration'
require 'jobi/config/rabbitmq'
require 'jobi/clients/rabbitmq'
require 'jobi/consumers/rabbitmq'

module Jobi
  class Error < StandardError; end

  class << self
    include Utils

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      configuration.setup_logger
      start
    end

    def logger
      configuration.logger
    end

    def session
      @session ||= client_class.new(configuration.send(client_config_method))
    end

    def client_class_name
      configuration.client.capitalize
    end

    def consumer?
      configuration.act_as_consumer
    end

    def publisher?
      configuration.act_as_publisher
    end

    private

    def client_config_method
      "#{client_class_name.downcase}_config"
    end

    def client_class
      constantize("Jobi::Clients::#{client_class_name}")
    end

    def start
      return unless consumer?

      configuration.jobs.each do |job_klass|
        constantize(job_klass).consume_messages
      end
    end
  end
end