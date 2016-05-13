Aws.config.update({
                      endpoint: ENV['aws_dynamo_endpoint'],
                      access_key_id: ENV['aws_access_key_id'],
                      secret_access_key: ENV['aws_secret_access_key'],
                      region: ENV['aws_region']
                  })