module Api
  module V1
    class PatientsController < ApplicationController
      # before_action :authenticate
      def queue_treatment_arm_assignment
        begin
          Aws::Publisher.publish({ queue_treatment_arm: {} })
          render json: { message: 'Message has been processed successfully' }, status: 200
        rescue => error
          standard_error_message(error)
        end
      end

      private

      def standard_error_message(error)
        logger.error error.message
        render json: { message: error.message }, status: 500
      end
    end
  end
end

