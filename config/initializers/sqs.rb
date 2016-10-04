
module Aws
  class Publisher

    attr_accessor :client, :url

    def self.publish(message, passed_queue_name = Rails.configuration.environment.fetch('queue_name'))
      begin
        @url = self.client.get_queue_url(queue_name: passed_queue_name).queue_url
        @client.send_message({queue_url: @url, :message_body => message.to_json})
      rescue Aws::SQS::Errors::ServiceError => error
        p error
      end
    end

    def self.client
      @client ||= Aws::SQS::Client.new(endpoint: "https://sqs.#{Aws.config[:region]}.amazonaws.com",
                                       credentials: Aws::Credentials.new(Aws.config[:access_key_id], Aws.config[:secret_access_key]))
    end
  end
end

