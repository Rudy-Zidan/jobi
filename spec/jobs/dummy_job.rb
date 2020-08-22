module Jobs
  class DummyJob < Jobi::Job
    options queue_name: :dummies,
            consumers: 2,
            persist: true

    def initialize(first:, second:)
      @first = first
      @second = second
    end

    def run
      @first + @second
    end
  end
end