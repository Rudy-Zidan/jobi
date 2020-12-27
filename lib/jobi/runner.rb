require 'jobi/utils'

module Jobi
  class Runner
    include Utils

    def initialize(payload:)
      @message = Marshal.load(payload)
    end

    def run
      job = @message.job_class.new(**@message.args)
      job.run
      job.send(@message.after_run) if @message.after_run

      Jobi.logger.info("Completed in: #{job_duration}")

      @message.id
    end

    private

    def job_duration
      Time.now.to_f - @message.started_at.to_f
    end
  end
end
