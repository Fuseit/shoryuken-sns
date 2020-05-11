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

        # Strip out namespaces from the publishing worker
        # class name
        if k == 'shoryuken_class'
          v[:string_value] = v[:string_value].split("::")[-1]
        end
      end if body['MessageAttributes']

      data.message_attributes = body['MessageAttributes'].symbolize_keys!
    end

    data
  end
end
