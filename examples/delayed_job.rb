$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'jobi'

$done = 0

class DelayedJob < Jobi::Job
  options queue_name: :calculators,
          ack: true,
          consumers: 10,
          durable: true,
          persist: true

  after_run :publish_result

  def initialize(a:, b:)
    @first = a
    @second = b
  end

  def run
    @sum = @first + @second
  end

  def publish_result
    $done += 1
    puts "publishing result: #{@sum}"
  end
end

Jobi.configure do |config|
  config.rabbitmq
  config.act_as_publisher = true
  config.act_as_consumer = true
  config.jobs = ['DelayedJob']
end

started_at = Time.now.to_f

(1..ENV['TIMES'].to_i).each do
  DelayedJob.delayed_run(10000, a: 1, b: 2)
end

while $done < ENV['TIMES'].to_i; sleep 10 end

puts "took: #{Time.now.to_f - started_at}"
