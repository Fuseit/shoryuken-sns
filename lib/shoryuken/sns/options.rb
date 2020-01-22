require 'shoryuken/options'

Shoryuken::Options.class_eval do
  attr_writer :sns_client

  def sns_client
    @sns_client ||= Aws::SNS::Resource.new
  end
end
