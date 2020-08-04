require 'jobi/utils'
require 'jobi/message'

module Jobi
  class Job
    class << self
      include Utils

      def options(queue_name:, ack: false, consumers: 5)
        @queue_name = queue_name.to_s
        @ack = ack
        @consumers = consumers
      end

      def after_run(callback)
        @after_run_callback = callback if callback
      end

      def run(**args)
        return unless Jobi.publisher?

        before_start(args)
        start
      rescue Error => e
        Jobi.logger.error('Failed to process the job')
        Jobi.logger.error(e)
      end

      def consume_messages
        return unless Jobi.consumer?

        join_queue

        @consumer_threads = []
        @consumers.times do
          @consumer_threads << Thread.new { consumer.consume! }
        end

        @consumer_threads.join(&:join)
      end

      private

      def before_start(args)
        create_message(args: args)
        log_job_info!
      end

      def start
        join_queue
        publish_message
        @message.id
      end

      def consumer
        class_const = constantize("Jobi::Consumers::#{Jobi.client_class_name}")
        class_const.new(queue: @queue, ack: @ack)
      end

      def join_queue
        @queue = Jobi.session
                     .queue(name: @queue_name)
      end

      def publish_message
        Jobi.session
            .publish(
              message: Marshal.dump(@message),
              queue: @queue
            )
      end

      def create_message(args:)
        @message = Message.new(
          job_class: self,
          args: args,
          after_run: @after_run_callback
        )
      end

      def log_job_info!
        Jobi.logger.info("A job has been started with id: [#{@message.id}]")
        Jobi.logger.debug("Queue: '#{@queue_name}'")
        Jobi.logger.debug("Args: #{@message.args}")
        Jobi.logger.debug("Job class: '#{@message.job_class}'")
      end
    end
  end
end