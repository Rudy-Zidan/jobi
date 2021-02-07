require 'bunny'

module Jobi
  module Clients
    class Rabbitmq

      QUEUE_OPTIONS = {
        durable: :durable
      }.freeze

      MESSAGE_OPTIONS = {
        persist: :persistent
      }.freeze

      def initialize(config = Jobi::Config::Rabbitmq.new)
        @channels = {}
        @connection = Bunny.new(config.to_h)
        @connection.start
      end

      def create_channel(queue_name)
        @channels[queue_name] ||= @connection.create_channel
      end

      def default_exchange
        @default_exchange ||= channel.default_exchange
      end

      def queue(name:, options: {})
        channel = create_channel(name)
        channel.prefetch(options[:prefetch])
        channel.queue(name, build_options(options, QUEUE_OPTIONS))
      end

      def publish(message:, queue:, options: {})
        queue.publish(message, build_options(options, MESSAGE_OPTIONS))
      end

      private

      def build_options(options = {}, original_options)
        options.inject({}) do |mapped_options, (key, value)|
          mapped_options[original_options[key]] = value
          mapped_options
        end
      end
    end
  end
end