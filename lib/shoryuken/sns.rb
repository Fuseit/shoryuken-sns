require 'shoryuken'
require 'aws-sdk-sns'

require 'shoryuken/worker/sns_executor'

require 'shoryuken/sns/topic'
require 'shoryuken/sns/client'
require 'shoryuken/sns/worker'
require 'shoryuken/sns/message'
require 'shoryuken/sns/options'
require 'shoryuken/sns/version'

module Shoryuken
  module Sns
  end
end

Shoryuken.module_eval do
  def_delegators(
    :shoryuken_options,
    :sns_client,
    :sns_client=
  )
end
