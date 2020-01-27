require 'shoryuken/message'

Shoryuken::Message.class_eval do
  def initialize(client, queue, data)
    self.client     = client
    self.data       = parse_data(data)
    self.queue_url  = queue.url
    self.queue_name = queue.name
  end

  private

  def parse_data(data)
    json = JSON.parse(data.body) rescue nil

    return data unless json

    if json['Type'] &&
       json['Type'] == 'Notification' &&
       json['TopicArn']
      data.body = json.delete('Message')
      data.message_attributes = json.delete('MessageAttributes')
    end

    data
  end
end
