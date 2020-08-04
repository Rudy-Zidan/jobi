require 'securerandom'

module Jobi
  module Utils
    def constantize(string)
      Object::const_get(string)
    end

    def generate_job_id
      SecureRandom.uuid
    end
  end
end