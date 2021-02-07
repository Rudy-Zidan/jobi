$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'jobi'

class FirstJob < Jobi::Job
  options queue_name: :first,
          ack: true,
          consumers: 10,
          durable: true,
          persist: true,
          prefetch: 10

  after_run :publish_result

  def initialize(a:, b:)
    @first = a
    @second = b
  end

  def run
    @sum = @first + @second
  end

  def publish_result
    puts "[1] publishing result: #{@sum}"
  end
end

class SecondJob < Jobi::Job
  options queue_name: :second,
          ack: true,
          consumers: 10,
          durable: true,
          persist: true,
          prefetch: 10

  after_run :publish_result

  def initialize(a:, b:)
    @first = a
    @second = b
  end

  def run
    @sum = @first + @second
  end

  def publish_result
    puts "[2] publishing result: #{@sum}"
  end
end

Jobi.configure do |config|
  config.rabbitmq
  config.act_as_publisher = true
  config.act_as_consumer = true
  config.jobs = ['FirstJob', 'SecondJob']
end

started_at = Time.now.to_f

(1..ENV['TIMES'].to_i).each do
  FirstJob.run(a: 1, b: 2)
  SecondJob.run(a: 1, b: 2)
end

puts "took: #{Time.now.to_f - started_at}"

loop {}