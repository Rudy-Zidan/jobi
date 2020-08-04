require 'bunny-mock'

before(:each) do
  @rabbitmq_client = BunnyMock.new.start
end