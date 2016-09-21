# TreatmentArms Controller which handles all the API calls for the
# TreatmentArm Ecosystem
module Api
  module V1
    class TreatmentArmsController < ApplicationController
      include HTTParty
      # before_action :authenticate, if: "Rails.env.production?"
      before_action :set_treatment_arms, only: ['index']
      before_action :set_treatment_arm, only: ['show']
      before_action :set_latest_treatment_arm, only: ['create']

      def create
        begin
          if @treatment_arm.nil?
            @treatment_arm = JSON.parse(request.raw_post)
            @treatment_arm.deep_transform_keys!(&:underscore).symbolize_keys!
            @treatment_arm.merge!(id: params[:id],
                                  stratum_id: params[:stratum_id],
                                  version: params[:version])
            if JSON::Validator.validate(TreatmentArmValidator.schema, @treatment_arm)
              Aws::Publisher.publish(treatment_arm: @treatment_arm)
              render json: { message: 'Message has been processed successfully' }, status: 200
            else
              JSON::Validator.validate!(TreatmentArmValidator.schema, @treatment_arm)
            end
          elsif @treatment_arm.version != params[:version]
            update_clone
          else
            raise "TreatmentArm with id: #{params[:id]}, stratum_id: #{params[:stratum_id]} and version: #{params[:version]} already exists in the DataBase. Ignoring"
          end
        rescue => error
          standard_error_message(error)
        end
      end

      def index
        begin
          if @basic_serializer == true
            render json: @treatment_arms, each_serializer: ::TreatmentArmBasicSerializer
          elsif params[:combine_variants].present?
            render json: @treatment_arms, each_serializer: ::TreatmentArmCombineSerializer
          else
            render json: @treatment_arms, each_serializer: ::TreatmentArmSerializer
          end
        rescue => error
          standard_error_message(error)
        end
      end

      def show
        begin
          if @basic_serializer == true
            render json: @treatment_arm, serializer: ::TreatmentArmBasicSerializer
          elsif params[:combine_variants].present?
            render json: @treatment_arm, serializer: ::TreatmentArmCombineSerializer
          else
            render json: @treatment_arm, serializer: ::TreatmentArmSerializer
          end
        rescue => error
          standard_error_message(error)
        end
      end

      def update_clone
        begin
          treatment_arm_hash = @treatment_arm.clone_attributes.merge!(clone_params)
          if JSON::Validator.validate(TreatmentArmValidator.schema, treatment_arm_hash)
            Aws::Publisher.publish(clone_treatment_arm: treatment_arm_hash)
            render json: { message: 'Message has been processed successfully' }, status: 200
          else
            JSON::Validator.validate!(TreatmentArmValidator.schema, treatment_arm_hash)
          end
        rescue => error
          standard_error_message(error)
        end
      end

      def assignment_event
        begin
          @assignment_event = JSON.parse(request.raw_post)
          @assignment_event.deep_transform_keys!(&:underscore).symbolize_keys!
          @assignment_event.merge!(treatment_arm_id: params[:id],
                                   stratum_id: params[:stratum_id],
                                   version: params[:version])
          Aws::Publisher.publish({ assignment_event: @assignment_event })
          render json: { message: 'Message has been processed successfully' }, status: 200
        rescue => error
          standard_error_message(error)
        end
      end

      private

      def set_treatment_arms
        params[:is_active_flag] = params[:active]
        params[:name] = params[:id]
        if params[:basic].present?
          @basic_serializer = params[:basic].downcase == 'true' ? true : false
        end
        Aws::Publisher.publish({ cog_treatment_refresh: {} }) if params[:refresh].try(:downcase) == 'true'
        ta_json = filter_query(TreatmentArm.all.entries)
        @treatment_arms = ta_json.sort{|x,y| y.date_created <=> x.date_created}
      end

      def set_treatment_arm
        @treatment_arm = filter_query(TreatmentArm.where(id: params[:id]).entries).first
        # standard_error_message('Unable to find treatment_arm with given details') if @treatment_arm.nil?
      end

      def set_latest_treatment_arm
        treatment_arms = TreatmentArm.where(id: params[:id], stratum_id: params[:stratum_id])
        @treatment_arm = treatment_arms.sort{|x,y| y.date_created <=> x.date_created}.first
      end

      def clone_params
        body_params = JSON.parse(request.raw_post)
        body_params.deep_transform_keys!(&:underscore).symbolize_keys!
        body_params[:new_version] = params[:version]
        [:id, :date_created, :version, :stratum_id].each { |k| body_params.delete(k) }
        body_params[:stratum_id] = params[:stratum_id]
        body_params
      end

      def filter_query(query_result)
        return [] if query_result.nil?
        [:id, :stratum_id, :version, :is_active_flag].each do |key|
          if params[key].present?
            new_query_result = query_result.select { |t| t.send(key) == params[key] }
            query_result = new_query_result
          end
        end
        query_result
      end

      def standard_error_message(error)
        logger.error error.message
        render json: { message: error.message }, status: 500
      end
    end
  end
end
