require 'spec_helper'

RSpec.describe Shoryuken::Message do
  MockMessage = Struct.new(:body, :message_attributes)

  let(:queue) { instance_double('Shoryuken::Queue', fifo?: false, name: 'default', url: 'default') }
  let(:client) { instance_double('Shoryuken::Client') }
  let(:queue_name) { 'default' }

  before do
    allow(Shoryuken::Client).to receive(:queues).with(queue_name).and_return(queue)
  end

  describe '#body' do
    let!(:data) { MockMessage.new(body, nil) }

    context 'when the data is a string' do
      let(:body) { "Test message" }

      subject { described_class.new(client, queue, data) }

      it 'returns an data as the message body' do
        expect(subject.body).to eq('Test message')
      end
    end

    context 'when the data is JSON' do
      let(:body) {{
        test: 'Message'
      }.to_json}

      subject { described_class.new(client, queue, data) }

      it 'returns an data as the message body' do
        expect(subject.body).to eq(body)
      end
    end

    context 'when the data is JSON from SNS' do
      let(:body) {{
        "Type" => "Notification",
        "TopicArn" => "default",
        "Message" => "test"
      }.to_json}

      subject { described_class.new(client, queue, data) }

      it 'returns an data as the message body' do
        expect(subject.body).to eq("test")
      end
    end
  end
end
