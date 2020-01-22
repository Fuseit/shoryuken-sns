require 'spec_helper'

RSpec.describe Shoryuken::Worker do
  let(:sns_topic) { double 'SNS Topic' }
  let(:topic)     { 'default' }

  before do
    allow(Shoryuken::Sns::Client).to receive(:topic).and_return(sns_topic)
  end

  describe '.shoryuken_options' do
    it 'registers a worker' do
      expect(Shoryuken.worker_registry.workers('default')).to eq([TestWorker])
    end

    it 'accepts a block as a topic' do
      $topic_prefix = 'production'

      class NewTestWorker
        include Shoryuken::Worker

        shoryuken_options topic: -> { "#{$topic_prefix}_default" }
      end

      expect(Shoryuken.worker_registry.workers('production_default')).to eq([NewTestWorker])
      expect(NewTestWorker.get_shoryuken_options['topic']).to eq 'production_default'
    end

    it 'does not change the original hash' do
      class TestWorker
        include Shoryuken::Worker

        OPT = { topic: :default }.freeze

        shoryuken_options OPT
      end

      expect(TestWorker::OPT['topic']).to eq(nil)
      expect(TestWorker.get_shoryuken_options['topic']).to eq('default')
      expect(TestWorker::OPT[:topic]).to eq(:default)
    end

    it 'accepts an array as a topic' do
      class WorkerMultipleTopics
        include Shoryuken::Worker

        shoryuken_options topic: %w[topic1 topic2 topic3]
      end

      expect(Shoryuken.worker_registry.workers('topic1')).to eq([WorkerMultipleTopics])
      expect(Shoryuken.worker_registry.workers('topic2')).to eq([WorkerMultipleTopics])
      expect(Shoryuken.worker_registry.workers('topic3')).to eq([WorkerMultipleTopics])
    end

    it 'is possible to configure the global defaults' do
      topic = SecureRandom.uuid
      Shoryuken.default_worker_options['topic'] = topic

      class GlobalDefaultsTestWorker
        include Shoryuken::Worker

        shoryuken_options auto_delete: true
      end

      expect(GlobalDefaultsTestWorker.get_shoryuken_options['topic']).to eq topic
      expect(GlobalDefaultsTestWorker.get_shoryuken_options['auto_delete']).to eq true
      expect(GlobalDefaultsTestWorker.get_shoryuken_options['batch']).to eq false
    end

    it 'accepts a symbol as a topic and converts to string' do
      class SymbolTopicTestWorker
        include Shoryuken::Worker

        shoryuken_options topic: :default
      end

      expect(SymbolTopicTestWorker.get_shoryuken_options['topic']).to eq 'default'
    end

    it 'accepts an array that contains symbols as a topic and converts to string' do
      class WorkerMultipleSymbolTopics
        include Shoryuken::Worker

        shoryuken_options topic: %i[symbol_topic1 symbol_topic2 symbol_topic3]
      end

      expect(Shoryuken.worker_registry.workers('symbol_topic1')).to eq([WorkerMultipleSymbolTopics])
      expect(Shoryuken.worker_registry.workers('symbol_topic2')).to eq([WorkerMultipleSymbolTopics])
      expect(Shoryuken.worker_registry.workers('symbol_topic3')).to eq([WorkerMultipleSymbolTopics])
    end

    it 'preserves parent class options' do
      class ParentWorker
        include Shoryuken::Worker

        shoryuken_options topic: 'mytopic', auto_delete: false
      end

      class ChildWorker < ParentWorker
        shoryuken_options auto_delete: true
      end

      expect(ParentWorker.get_shoryuken_options['topic']).to eq('mytopic')
      expect(ChildWorker.get_shoryuken_options['topic']).to eq('mytopic')
      expect(ParentWorker.get_shoryuken_options['auto_delete']).to eq(false)
      expect(ChildWorker.get_shoryuken_options['auto_delete']).to eq(true)
    end
  end

  describe '.server_middleware' do
    before do
      class FakeMiddleware
        def call(*_args)
          yield
        end
      end
    end

    context 'no middleware is defined in the worker' do
      it 'returns the list of global middlewares' do
        expect(TestWorker.server_middleware).to satisfy do |chain|
          chain.exists?(Shoryuken::Middleware::Server::Timing)
        end

        expect(TestWorker.server_middleware).to satisfy do |chain|
          chain.exists?(Shoryuken::Middleware::Server::AutoDelete)
        end
      end
    end

    context 'the worker clears the middleware chain' do
      before do
        class NewTestWorker2
          include Shoryuken::Worker

          server_middleware(&:clear)
        end
      end

      it 'returns an empty list' do
        expect(NewTestWorker2.server_middleware.entries).to be_empty
      end

      it 'does not affect the global middleware chain' do
        expect(Shoryuken.server_middleware.entries).not_to be_empty
      end
    end

    context 'the worker modifies the chain' do
      before do
        class NewTestWorker3
          include Shoryuken::Worker

          server_middleware do |chain|
            chain.remove Shoryuken::Middleware::Server::Timing
            chain.insert_before Shoryuken::Middleware::Server::AutoDelete, FakeMiddleware
          end
        end
      end

      it 'returns the combined global and worker middlewares' do
        expect(NewTestWorker3.server_middleware).not_to satisfy do |chain|
          chain.exists?(Shoryuken::Middleware::Server::Timing)
        end

        expect(NewTestWorker3.server_middleware).to satisfy do |chain|
          chain.exists?(FakeMiddleware)
        end

        expect(NewTestWorker3.server_middleware).to satisfy do |chain|
          chain.exists?(Shoryuken::Middleware::Server::AutoDelete)
        end
      end

      it 'does not affect the global middleware chain' do
        expect(Shoryuken.server_middleware).to satisfy do |chain|
          chain.exists?(Shoryuken::Middleware::Server::Timing)
        end

        expect(Shoryuken.server_middleware).to satisfy do |chain|
          chain.exists?(Shoryuken::Middleware::Server::AutoDelete)
        end

        expect(Shoryuken.server_middleware).not_to satisfy do |chain|
          chain.exists?(FakeMiddleware)
        end
      end
    end
  end
end
