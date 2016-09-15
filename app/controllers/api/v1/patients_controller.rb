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

      def patient_assignment
        begin
          @patient_assignment = JSON.parse(request.raw_post)
          @patient_assignment.deep_transform_keys!(&:underscore).symbolize_keys!
          Aws::Publisher.publish({ patient_assignment: @patient_assignment })
          render json: { message: 'Message has been processed successfully' }, status: 200
          # if JSON::Validator.validate(PatientAssignmentValidator.schema, @patient_assignment)
          #   Aws::Publisher.publish({:patient_assignment => @patient_assignment})
          #   render json: {:status => "SUCCESS"}, :status => 200
          # else
          #   JSON::Validator.validate!(PatientAssignmentValidator.schema, @patient_assignment)
          # end
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
