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

      # Checks if the TreatmentArm exists in the DB, if not Creates it
      def create
        begin
          if @treatment_arm.nil?
            @treatment_arm = JSON.parse(request.raw_post)
            @treatment_arm.deep_transform_keys!(&:underscore).symbolize_keys!
            @treatment_arm.merge!(treatment_arm_id: params[:treatment_arm_id],
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
            render json: { message: "TreatmentArm with id: #{params[:treatment_arm_id]}, stratum_id: #{params[:stratum_id]} and version: #{params[:version]} already exists in the DataBase" }, status: 400
          end
        rescue => error
          standard_error_message(error)
        end
      end

      # This shows a list of all the TreatmentArms present in the Database & also lists all the versions of a TreatmentArm
      def index
        begin
          if projection_params.present? || attribute_params.present?
            render json: TreatmentArm.serialized_hash(@treatment_arms, projection_params || [])
          else
            render json: @treatment_arms, each_serializer: ::TreatmentArmSerializer
          end
        rescue => error
          standard_error_message(error)
        end
      end

      # This gets the latest TreatmentArm Status from COG when 'PUT /api/v1/treatment_arms/status' is hit
      def refresh
        begin
          TreatmentArm.async_cog_status_update
          treatment_arms = TreatmentArm.where(is_active_flag: true).all
          render json: treatment_arms.as_json
        rescue => error
          standard_error_message(error)
        end
      end

      # This retrieves a Specific TreatmentArm
      def show
        begin
          if projection_params.present? || attribute_params.present?
            render json: TreatmentArm.serialized_hash(@treatment_arm, projection_params || [])
          else
            render json: @ta# serializer: ::TreatmentArmSerializer
          end
        rescue => error
          standard_error_message(error)
        end
      end

      # This creates TreatmentArm into the Database with the new version
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

      # This Assigns a PatientAssignment to a particular TreatmentArm
      def assignment_event
        begin
          @assignment_event = JSON.parse(request.raw_post)
          @assignment_event.deep_transform_keys!(&:underscore).symbolize_keys!
          @assignment_event.merge!(treatment_arm_id: params[:treatment_arm_id],
                                   stratum_id: params[:stratum_id],
                                   version: params[:version])
          Aws::Publisher.publish(assignment_event: @assignment_event)
          render json: { message: 'Message has been processed successfully' }, status: 200
        rescue => error
          standard_error_message(error)
        end
      end

      def patients_on_treatment_arm
        begin
          unless params[:treatment_arm_id].nil?
            treatment_arm_json = TreatmentArmAssignmentEvent.find_with_variant_stats(params[:treatment_arm_id], params[:stratum_id]) || []
            render json: treatment_arm_json
          end
        rescue => error
          standard_error_message(error)
        end
      end

      private

      def set_treatment_arms
        if params[:active].present?
          params[:is_active_flag] = params[:active] == 'true' ?  true : false
        end
        if attribute_params.present? || projection_params.present?
          ta_json = filter_query_by_attributes(TreatmentArm.all.entries)
        else
          ta_json = filter_query(TreatmentArm.all.entries)
        end
        @treatment_arms = ta_json.sort{ |x, y| y.date_created <=> x.date_created }
      end

      def set_treatment_arm
        #set_treatment_arms
        #@treatment_arm = @treatment_arms.first
        @ta = TreatmentArm.where(treatment_arm_id: params[:treatment_arm_id], stratum_id: params[:stratum_id], version: params[:version] )
        error_message(Error.new('Resource Not Found')) if @ta.nil? || @ta.count == 0
      end

      def set_latest_treatment_arm
        treatment_arms = TreatmentArm.where(treatment_arm_id: params[:treatment_arm_id], stratum_id: params[:stratum_id])
        @treatment_arm = treatment_arms.detect{|t| t.version == params[:version]}
        @treatment_arm = treatment_arms.sort{ |x, y| y.date_created <=> x.date_created }.first unless @treatment_arm
      end

      def clone_params
        body_params = JSON.parse(request.raw_post)
        body_params.deep_transform_keys!(&:underscore).symbolize_keys!
        body_params[:new_version] = params[:version]
        [:treatment_arm_id, :date_created, :version, :stratum_id].each { |k| body_params.delete(k) }
        body_params[:stratum_id] = params[:stratum_id]
        body_params
      end

      def projection_params
        if params[:projection].is_a?(Array)
          projection = params[:projection] || []
          projection.map(&:to_sym)
        end
      end

      def attribute_params
        if params[:attribute].is_a?(Array)
          attribute = params[:attribute] || []
          attribute.map(&:to_sym)
        end
      end

      def filter_query(query_result)
        return [] if query_result.nil?
        [:treatment_arm_id, :stratum_id, :version, :is_active_flag].each do |key|
          unless params[key].nil?
            new_query_result = query_result.select { |t| t.send(key) == params[key] }
            query_result = new_query_result
          end
        end
        query_result
      end

      def filter_query_by_attributes(query_result)
        return [] if query_result.nil?
        unless attribute_params.nil?
          attribute_params.each do |key|
            new_query_result = query_result.select do |t|
              t.send(key).present?
            end
            query_result = new_query_result
          end
        end
        query_result = filter_query(query_result)
        query_result || []
      end

      def standard_error_message(error)
        logger.error error.message
        puts "#{error.backtrace}"
        render json: { message: error.message }, status: 500
      end

      def error_message(error)
        logger.error error.message
        puts "#{error.backtrace}"
        render json: { message: error.message }, status: 404
      end
    end
  end
end
