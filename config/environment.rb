# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'item_operations'
require 'model_serializer'
# Initialize the Rails application.
Rails.application.initialize!
Aws::Sqs::Publisher.set_queue_name(Rails.configuration.environment.fetch('queue_name'))
