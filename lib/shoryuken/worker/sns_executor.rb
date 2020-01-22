module Shoryuken
  module Worker
    class SnsExecutor
      class << self
        def perform_async(worker_class, body, options = {})
          options[:message_attributes] ||= {}
          options[:message_attributes]['shoryuken_class'] = {
            string_value: worker_class.to_s,
            data_type: 'String'
          }

          options[:message] = body

          queue = options.delete(:topic) || worker_class.get_shoryuken_options['topic']

          Shoryuken::Sns::Client.topics(topic).send_message(options)
        end

        def perform_in(worker_class, interval, body, options = {})
          fail NotImplementedError
        end
      end
    end
  end
end
