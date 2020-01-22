require 'shoryuken'

require 'shoryuken/worker/sns_executor'

require 'shoryuken/sns/topic'
require 'shoryuken/sns/client'
require 'shoryuken/sns/options'
require 'shoryuken/sns/version'

module Shoryuken
  module Sns
  end
end

Shoryuken.module_eval do
  def_delegators(
    :shoryuken_options,
    :active_job?,
    :add_group,
    :groups,
    :add_queue,
    :ungrouped_queues,
    :worker_registry,
    :worker_registry=,
    :worker_executor,
    :worker_executor=,
    :launcher_executor,
    :launcher_executor=,
    :polling_strategy,
    :start_callback,
    :start_callback=,
    :stop_callback,
    :stop_callback=,
    :active_job_queue_name_prefixing?,
    :active_job_queue_name_prefixing=,
    :sns_client,
    :sns_client=,
    :sqs_client,
    :sqs_client=,
    :sqs_client_receive_message_opts,
    :sqs_client_receive_message_opts=,
    :options,
    :logger,
    :register_worker,
    :configure_server,
    :server?,
    :server_middleware,
    :configure_client,
    :client_middleware,
    :default_worker_options,
    :default_worker_options=,
    :on_start,
    :on_stop,
    :on,
    :cache_visibility_timeout?,
    :cache_visibility_timeout=,
    :delay
  )
end
