require 'shoryuken/worker'

module Shoryuken
  module Sns
    module Worker
      def self.included(base)
        base.extend(ClassMethods)
        base.shoryuken_class_attribute :shoryuken_options_hash
      end

      module ClassMethods
        include Shoryuken::Worker::ClassMethods

        def perform_async(body, options = {})
          executor = Shoryuken::Worker::SnsExecutor

          # Try to keep the ability to still execute inline
          # while still forcing publishing to SNS when using
          # this worker
          if Shoryuken.worker_executor == Shoryuken::Worker::InlineExecutor
            executor = Shoryuken::Worker::InlineExecutor
          end

          executor.perform_async(self, body, options)
        end

        def perform_in(interval, body, options = {})
          # SNS does support delayed messages
          fail NotImplementedError
        end

        def shoryuken_options(opts = {})
          self.shoryuken_options_hash = get_shoryuken_options.merge(stringify_keys(opts || {}))
          normalize_worker_topic!
        end

        private

        def normalize_worker_topic!
          shoryuken_options_hash['topic'] = shoryuken_options_hash['topic'].to_s
        end
      end
    end
  end
end
