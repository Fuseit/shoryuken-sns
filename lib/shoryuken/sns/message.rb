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
    body = JSON.parse(data.body) rescue nil

    return data unless body

    if body['Type'] &&
       body['Type'] == 'Notification' &&
       body['TopicArn']
      data.body = body['Message']

      # Undo the changes to attributes that SNS applies
      body['MessageAttributes'].each do |k,v|
        v[:data_type] = v.delete('Type')
        v[:string_value] = v.delete('Value')
      end if body['MessageAttributes']

      data.message_attributes = body['MessageAttributes']
    end

    data
  end
end
