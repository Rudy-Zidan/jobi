module Jobi
  class Configuration
    attr_accessor :log_file, :act_as_publisher, :act_as_consumer, :jobs
    attr_writer :log_level
    attr_reader :logger, :rabbitmq_config, :client

    def initialize
      setup_client
      setup_log_config
      setup_logger
      setup_pub_sub_config
      setup_jobs
      rabbitmq
    end

    def log_level
      case @log_level
      when :info
        Logger::INFO
      when :warn
        Logger::WARN
      when :debug
        Logger::DEBUG
      end
    end

    def rabbitmq(options = {})
      @rabbitmq_config ||= Jobi::Config::Rabbitmq.new
      @client = :rabbitmq

      options.keys.each do |key|
        @rabbitmq_config.send("#{key}=", options[key])
      end
    end

    def setup_logger
      @logger = if @log_file
                  Logger.new(@log_file)
                else
                  Logger.new(STDOUT)
                end

      @logger.level = @log_level
    end

    private

    def setup_log_config
      @log_level = :info
      @log_file = nil
    end

    def setup_client
      @client = :rabbitmq
    end

    def setup_pub_sub_config
      @act_as_publisher = true
      @act_as_consumer = true
    end

    def setup_jobs
      @jobs = []
    end
  end
end