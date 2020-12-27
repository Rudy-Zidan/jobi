require 'bunny'

module Jobi
  module Clients
    class Rabbitmq

      QUEUE_OPTIONS = {
        durable: :durable,
        __headers: {}
      }.freeze

      MESSAGE_OPTIONS = {
        persist: :persistent,
        __headers: {
          delay: 'x-delay'
        }
      }.freeze

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

      def delayed_exchange
        @delayed_exchange ||= channel.exchange(
          'jobi.delayed_exchange',
          {
            type: 'x-delayed-message',
            arguments: { 'x-delayed-type': 'direct' },
          },
        )
      end

      def exchange!(type)
        send("#{type}_exchange")
      end

      def queue(name:, options: {})
        exchange = exchange!(exchange_type(options))
        queue = channel.queue(name, build_options(options, QUEUE_OPTIONS))
        bind_exchange(queue, exchange)

        queue
      end

      def publish(message:, queue:, options: {})
        publisher = {
          delayed: @delayed_exchange,
        }.fetch(exchange_type(options), queue)

        publisher.publish(message, build_options(options, MESSAGE_OPTIONS))
      end

      private

      def exchange_type(options)
        if options[:delay]&.positive?
          :delayed
        else
          :default
        end
      end

      def bind_exchange(queue, exchange)
        return if exchange.name.empty?

        queue.bind(exchange)
      end

      def build_options(options = {}, original_options)
        options.inject({ headers: {} }) do |mapped_options, (key, value)|
          if mapped_key = original_options[key]
            mapped_options[mapped_key] = value
          elsif mapped_key = original_options[:__headers][key]
            mapped_options[:headers][mapped_key] = value
          end
          mapped_options
        end
      end
    end
  end
end