require 'jobi/utils'

module Jobi
  class Message
    include Utils

    attr_reader :id, :job_class, :args, :started_at, :after_run

    def initialize(job_class:, args:, after_run: nil)
      @id = generate_job_id
      @job_class = job_class
      @args = args
      @started_at = Time.now.to_f
      @after_run = after_run
    end
  end
end