module Jobi
  module Config
    class Rabbitmq
      attr_accessor :host, :port, :user, :pass, :vhost,
                    :heartbeat, :automatically_recover,
                    :network_recovery_interval, :threaded, :ssl,
                    :continuation_timeout, :frame_max, :auth_mechanism

      def initialize
        setup_server_config
        setup_network_config
        setup_processing_config
      end

      def to_h
        {
          host: @host,
          port: @port,
          user: @user,
          pass: @pass,
          vhost: @vhost,
          auth_mechanism: @auth_mechanism,
          heartbeat: @heartbeat,
          automatically_recover: @automatically_recover,
          network_recovery_interval: @network_recovery_interval,
          ssl: @ssl,
          threaded: @threaded,
          continuation_timeout: @continuation_timeout,
          frame_max: @frame_max
        }
      end

      private

      def setup_server_config
        @host = '127.0.0.1'
        @port = '5672'
        @user = 'guest'
        @pass = 'guest'
        @vhost = '/'
        @auth_mechanism = 'PLAIN'
      end

      def setup_network_config
        @heartbeat = :server
        @automatically_recover = true
        @network_recovery_interval = 5.0
        @ssl = false
      end

      def setup_processing_config
        @threaded = true
        @continuation_timeout = 4000
        @frame_max = 131_072
      end
    end
  end
end