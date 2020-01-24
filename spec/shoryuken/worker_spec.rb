require 'spec_helper'

RSpec.describe Shoryuken::Sns::Worker do
  let(:sns_topic) { double 'SNS Topic' }
  let(:topic)     { 'default' }

  before do
    allow(Shoryuken::Sns::Client).to receive(:topic).and_return(sns_topic)
  end

  describe '.shoryuken_options' do
    it 'accepts a symbol as a topic and converts to string' do
      class SymbolTopicTestWorker
        include Shoryuken::Sns::Worker

        shoryuken_options topic: :default
      end

      expect(SymbolTopicTestWorker.get_shoryuken_options['topic']).to eq 'default'
    end
  end
end
