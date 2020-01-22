module Shoryuken
  module Sns
    class Client
      @@topics = {}

      class << self
        def topics(arn)
          @@topics[arn] ||= Shoryuken::Sns::Topic.new(sns, arn)
        end

        def sns
          Shoryuken.sns_client
        end

        def sns=(sns)
          # Since the @@topics values (Shoryuken::Queue objects) are built referencing @@sns, if it changes, we need to
          #   re-build them on subsequent calls to `.topics(arn)`.
          @@topics = {}

          Shoryuken.sns_client = sns
        end
      end
    end
  end
end
