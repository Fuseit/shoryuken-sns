module Shoryuken
  module Sns
    class Topic
      attr_accessor :arn, :client

      def initialize client, arn
        self.arn = arn
        self.client = client
      end

      def delete_messages options
        fail NotImplementedError
      end

      def send_message options
        options = sanitize_message!(options).merge(topic_arn: arn)

        Shoryuken.client_middleware.invoke(options) do
          topic.publish(options)
        end
      end

      def send_messages(options)
        fail NotImplementedError
      end

      private

      def topic
        client.topic(arn)
      end

      def sanitize_message!(options)
        options = { message: options } if options.is_a?(String)

        if (body = options[:message]).is_a?(Hash)
          options[:message] = JSON.dump(body)
        end

        options
      end
    end
  end
end
