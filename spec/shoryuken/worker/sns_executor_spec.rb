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
  end
end
