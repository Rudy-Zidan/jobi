module Jobi
  module Clients
    RSpec.describe Rabbitmq do
      let(:config) { Jobi::Config::Rabbitmq.new }
      let(:client) do
        allow(Bunny).to receive(:new).and_return(BunnyMock.new(config.to_h))
        described_class.new(config)
      end

      context 'initialization' do
        before :each do
          @connection = client.instance_variable_get(:@connection)
        end

        it 'should declare an instance variable called connection' do
          expect(@connection).to be_truthy
        end

        it 'should start a connection' do
          expect(@connection.open?).to be_truthy
        end
      end

      context 'channel creation' do
        it 'should have an instance variable called channels' do
          queue_name = 'test_queue'
          client.create_channel(queue_name)
          channels = client.instance_variable_get(:@channels)

          expect(channels).to be_truthy
          expect(channels.class).to be(Hash)
          expect(channels.keys.first).to eq(queue_name)
        end

        it 'should create channel per queue' do
          first_queue_name = 'first_queue'
          second_queue_name = 'second_queue'

          [first_queue_name, second_queue_name].each do |queue_name|
            client.create_channel(queue_name)
          end
          
          channels = client.instance_variable_get(:@channels)

          expect(channels).to be_truthy
          expect(channels.class).to be(Hash)
          expect(channels.keys.size).to eq(2)
          expect(channels.keys.first).to eq(first_queue_name)
          expect(channels.keys.last).to eq(second_queue_name)
        end
      end

      context 'queue creation' do
        before :each do
          @queue_name = 'test.queue'
          @queue = client.queue(
            name: @queue_name,
            options: { durable: true }
          )
        end

        it 'should be exists on rabbitmq' do
          @connection = client.instance_variable_get(:@connection)
          exists = @connection.queue_exists?(@queue_name)

          expect(exists).to be_truthy
        end

        it 'should be with the same given name' do
          expect(@queue.name).to equal(@queue_name)
        end

        it 'should be a durable queue' do
          @options = @queue.instance_variable_get(:@opts)
          expect(@options[:durable]).to be_truthy
        end
      end

      context 'publishing message' do
        before :each do
          @queue = client.queue(name: 'test.publish.queue')
          @message = 'publish this message'

          client.publish(
            message: @message,
            queue: @queue
          )
        end

        it 'should be the same message' do
          @queue.subscribe do |_, _, payload|
            expect(payload).to be(@message)
          end
        end
      end
    end
  end
end