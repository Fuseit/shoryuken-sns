require 'spec_helper'

RSpec.describe Shoryuken::Worker::SnsExecutor do
  let(:sqs_topic) { double 'SQS Topic' }
  let(:topic)     { 'default' }

  before do
    allow(Shoryuken::Sns::Client).to receive(:topics).with(topic).and_return(sqs_topic)
  end

  describe '.perform_async' do
    it 'entopics a message' do
      expect(sqs_topic).to receive(:send_message).with(
        message_attributes: {
          'shoryuken_class' => {
            string_value: TestWorker.to_s,
            data_type: 'String'
          }
        },
        message: 'message'
      )

      TestWorker.perform_async('message')
    end

    it 'accepts an `topic` option' do
      new_topic = 'some_different_topic'

      expect(Shoryuken::Sns::Client).to receive(:topics).with(new_topic).and_return(sqs_topic)

      expect(sqs_topic).to receive(:send_message).with(
        message_attributes: {
          'shoryuken_class' => {
            string_value: TestWorker.to_s,
            data_type: 'String'
          }
        },
        message: 'delayed message'
      )

      TestWorker.perform_async('delayed message', topic: new_topic)
    end

    context 'when it verifies subscriptions' do
      before do
        allow(Shoryuken::Sns::Client).to receive(:topics).with(topic).and_return(sqs_topic)
      end

      class TestVerifySubscriptionsWorker
        include Shoryuken::Sns::Worker

        shoryuken_options queue: 'default', topic: 'default', verify_subscriptions: true

        def perform(sns_msg, arg); end
      end

      subject { TestVerifySubscriptionsWorker.perform_async('message') }

      it 'raises an error when there are no subscriptions' do
        expect(sqs_topic).to receive_message_chain([:list_subscriptions, :count]).and_return(0)
        expect { subject }.to raise_error(Shoryuken::Worker::NoSubscriptionsError, "No subscriptions for default")
      end

      it 'does not raise an error when there are subscriptions' do
        expect(sqs_topic).to receive_message_chain([:list_subscriptions, :count]).and_return(1)
        expect(sqs_topic).to receive(:send_message)
        expect { subject }.not_to raise_error
      end
    end
  end
end
