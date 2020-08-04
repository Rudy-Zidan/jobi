require 'jobi/runner'
require 'bunny'

module Jobi
  module Consumers
    class Rabbitmq
      def initialize(queue:, ack:)
        @queue = queue
        @ack = ack
      end

      def consume!
        @queue.subscribe(manual_ack: @ack) do |delivery_info, metadata, payload|
          Jobi::Runner.new(payload: payload).run
          acknowledge!(delivery_info.delivery_tag) if @ack
        end
      end

      private

      def acknowledge!(delivery_tag)
        @queue.channel.acknowledge(delivery_tag, false)
      end
    end
  end
end