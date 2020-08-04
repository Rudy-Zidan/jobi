require 'bunny'

module Jobi
  module Clients
    class Rabbitmq
      def initialize(config = Jobi::Config::Rabbitmq.new)
        @connection = Bunny.new(config.to_h)
        @connection.start
      end

      def channel
        @channel ||= @connection.create_channel
      end

      def default_exchange
        @default_exchange ||= channel.default_exchange
      end

      def queue(name:, options: {})
        default_exchange
        channel.queue(name)
      end

      def publish(message:, queue:, options: {})
        queue.publish(message)
      end
    end
  end
end