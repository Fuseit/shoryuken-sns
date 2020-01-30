module Shoryuken
  module Worker
    class NoSubscriptionsError < StandardError; end

    class SnsExecutor
      class << self
        def perform_async(worker_class, body, options = {})
          options[:message_attributes] ||= {}
          options[:message_attributes]['shoryuken_class'] = {
            string_value: worker_class.to_s,
            data_type: 'String'
          }

          options[:message] = body

          topic = options.delete(:topic) || worker_class.get_shoryuken_options['topic']
          client = Shoryuken::Sns::Client.topics(topic)

          if worker_class.get_shoryuken_options['verify_subscriptions'] && client.list_subscriptions.count < 1
            raise Shoryuken::Worker::NoSubscriptionsError, "No subscriptions for #{topic}"
          end

          client.send_message(options)
        end

        def perform_in(worker_class, interval, body, options = {})
          fail NotImplementedError
        end
      end
    end
  end
end
