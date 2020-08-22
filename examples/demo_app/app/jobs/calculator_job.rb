class CalculatorJob < ApplicationJob
  options queue_name: :calculator,
          ack: true,
          consumers: 5,
          durable: true,
          persist: true

  def initialize(number1:, number2:)
    @number1 = number1
    @number2 = number2
  end

  def run
    @number1 + @number2
  end
end