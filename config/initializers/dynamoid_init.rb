# Dynamoid Configuration
 Dynamoid.configure do |config|
   config.adapter = 'aws_sdk_v2' # This adapter establishes a connection to the
   # DynamoDB servers using Amazon's own AWS gem.
   config.namespace = nil
   config.warn_on_scan = true # Output a warning to the logger
   # when you perform a scan rather than a query on a table.
   config.read_capacity = 5 # Read capacity for your tables
   config.write_capacity = 5 # Write capacity for your tables
   # config.endpoint = 'http://localhost:3000' # [Optional]
   # If provided, it communicates with the DB listening at the endpoint.
   # This is useful for testing with [Amazon Local DB]
   # (http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html).
 end