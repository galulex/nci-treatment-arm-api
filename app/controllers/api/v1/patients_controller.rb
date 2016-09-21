module Api
  module V1
    class PatientsController < ApplicationController
      # before_action :authenticate
      def patient_on_treatment_arm
        begin
          unless params[:id].nil?
            treatment_arm_json = TreatmentArmAssignmentEvent.find_by(patient_id: params[:id])
            render json: treatment_arm_json
          end
        rescue => error
          standard_error_message(error)
        end
      end

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
