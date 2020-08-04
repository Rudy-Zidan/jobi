$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'jobi'

class NormalJob < Jobi::Job
  options queue_name: :calculators,
          ack: true,
          consumers: 10

  after_run :publish_result

  def initialize(a:, b:)
    @first = a
    @second = b
  end

  def run
    @sum = @first + @second
  end

  def publish_result
    puts "publishing result: #{@sum}"
  end
end

Jobi.configure do |config|
  config.rabbitmq
  config.act_as_publisher = true
  config.act_as_consumer = true
  config.jobs = ['NormalJob']
end

started_at = Time.now.to_f

(1..ENV['TIMES'].to_i).each do
  NormalJob.run(a: 1, b: 2)
end

puts "took: #{Time.now.to_f - started_at}"
