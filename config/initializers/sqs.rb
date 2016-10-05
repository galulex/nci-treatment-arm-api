
module Aws
  class Publisher

    attr_accessor :client, :url, :queue_name

    def self.publish(message)
      begin
        @url = self.client.get_queue_url(queue_name: @queue_name).queue_url
        @client.send_message({queue_url: @url, :message_body => message.to_json})
      rescue Aws::SQS::Errors::ServiceError => error
        puts error
      end
    end

    def self.client
      @client ||= Aws::SQS::Client.new(endpoint: "https://sqs.#{Aws.config[:region]}.amazonaws.com",
                                       credentials: Aws::Credentials.new(Aws.config[:access_key_id], Aws.config[:secret_access_key]))
    end

    def self.set_queue_name(queue_name)
      @queue_name = queue_name
    end

  end
end

