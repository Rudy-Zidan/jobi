Jobi.configure do |config|
  config.rabbitmq
  config.act_as_publisher = true
  config.act_as_consumer = true
  config.jobs = ['CalculatorJob']
  config.log_file = 'log/jobi.log'
  config.log_level = :debug
end