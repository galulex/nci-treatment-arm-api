# TreatmentArms Controller which handles all the API calls for the
# TreatmentArm Ecosystem
module Api::V1
  class TreatmentArmsController < ApplicationController
    include HTTParty

    before_action :authenticate_user
    load_and_authorize_resource only: [:create, :assignment_event, :refresh]
    before_action :params_to_boolean, only: %w(index show)
    before_action :set_treatment_arms, only: ['index']
    before_action :set_treatment_arm, only: ['show']
    before_action :set_latest_treatment_arm, only: ['create']

    # Checks if the TreatmentArm exists in the DB, if not Creates it
    def create
      begin
        if @treatment_arm.nil?
          @treatment_arm = JSON.parse(request.raw_post)
          TreatmentArm.remove_trailing_spaces(@treatment_arm)
          @treatment_arm.deep_transform_keys!(&:underscore).symbolize_keys!
          @treatment_arm.merge!(treatment_arm_id: params[:treatment_arm_id],
                                stratum_id: params[:stratum_id],
                                version: params[:version])
          if JSON::Validator.validate(TreatmentArmValidator.schema, @treatment_arm)
            Rails.logger.info("===== TreatmentArm('#{params[:treatment_arm_id]}'/'#{params[:stratum_id]}'/'#{params[:version]}') Validation passed =====")
            Rails.logger.info("===== Sending TreatmentArm('#{params[:treatment_arm_id]}'/'#{params[:stratum_id]}'/'#{params[:version]}') onto the queue =====")
            Aws::Publisher.publish(treatment_arm: @treatment_arm)
            render json: { message: 'Message has been processed successfully' }, status: 202
          else
            Rails.logger.info("===== TreatmentArm('#{params[:treatment_arm_id]}'/'#{params[:stratum_id]}'/'#{params[:version]}') Validation failed =====")
            JSON::Validator.validate!(TreatmentArmValidator.schema, @treatment_arm)
          end
        elsif @treatment_arm.version != params[:version] && fail_safe(@treatment_arm.date_created)
          update_clone
        else
          render json: { message: "TreatmentArm with treatment_arm_id: '#{params[:treatment_arm_id]}', stratum_id: '#{params[:stratum_id]}' and version: '#{params[:version]}' already exists in the DataBase" }, status: 400
        end
      rescue => error
        standard_error_message(error)
      end
    end

    def fail_safe(date_created)
      updated_treatment_arm = JSON.parse(request.raw_post)
      raise "The date created cannot be the same as previous TreatmentArm's date created" if date_created == updated_treatment_arm['date_created']
      true if date_created != updated_treatment_arm['date_created']
    end

    # This shows a list of all the TreatmentArms present in the Database & also lists all the versions of a TreatmentArm
    def index
      begin
        if check_params
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
        response = TreatmentArm.async_cog_status_update
        render json: response
      rescue => error
        standard_error_message(error)
      end
    end

    # This retrieves a Specific TreatmentArm
    def show
      begin
        if check_params
          render json: TreatmentArm.serialized_hash(@treatment_arm, projection_params || [])
        else
          render json: @treatment_arm, each_serializer: ::TreatmentArmSerializer
        end
      rescue => error
        standard_error_message(error)
      end
    end

    def check_params
      true if projection_params.present? || attribute_params.present?
    end

    # This creates TreatmentArm into the Database with the new version
    def update_clone
      begin
        treatment_arm = @treatment_arm.attributes_data.merge!(clone_params).compact
        treatment_arm_hash = treatment_arm.symbolize_keys.tap { |ta| ta.delete(:status_log) }
        clone_treatment_arm = treatment_arm_hash.merge(status_log: { Time.now.to_i.to_s => treatment_arm_hash[:treatment_arm_status] })
        if JSON::Validator.validate(TreatmentArmValidator.schema, clone_treatment_arm)
          Rails.logger.info("===== TreatmentArm('#{params[:treatment_arm_id]}'/'#{params[:stratum_id]}'/'#{params[:version]}') Validation passed =====")
          Rails.logger.info("===== Sending TreatmentArm('#{params[:treatment_arm_id]}'/'#{params[:stratum_id]}' & with new version '#{params[:version]}') onto the queue =====")
          Aws::Publisher.publish(clone_treatment_arm: clone_treatment_arm)
          render json: { message: 'Message has been processed successfully' }, status: 202
        else
          Rails.logger.info("===== TreatmentArm('#{params[:treatment_arm_id]}'/'#{params[:stratum_id]}'/'#{params[:version]}') Validation failed =====")
          JSON::Validator.validate!(TreatmentArmValidator.schema, clone_treatment_arm)
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
        Rails.logger.info("===== TreatmentArm('#{params[:treatment_arm_id]}'/'#{params[:stratum_id]}'/'#{params[:version]}') received a Patient Assignment =====")
        Rails.logger.info('===== Sending the Patient Assignment onto the queue =====')
        Aws::Publisher.publish(assignment_event: @assignment_event)
        render json: { message: 'Message has been processed successfully' }, status: 202
      rescue => error
        standard_error_message(error)
      end
    end

    def patients_on_treatment_arm
      begin
        unless params[:treatment_arm_id].nil?
          treatment_arm_json = TreatmentArmAssignmentEvent.find_with_variant_stats(params[:treatment_arm_id], params[:stratum_id], params[:treatment_arm_status]) || []
          render json: treatment_arm_json
        end
      rescue => error
        standard_error_message(error)
      end
    end

    private

    def set_treatment_arms
      params[:active] == 'true' ? true : false if params[:active].present?
      if attribute_params.present? || projection_params.present?
        ta_json = filter_query_by_attributes(TreatmentArm.scan({}))
      else
        ta_json = filter_query(TreatmentArm.scan({}))
      end
      @treatment_arms = ta_json.sort { |x, y| y.date_created <=> x.date_created }
    end

    def set_treatment_arm
      treatment_arm_id = params[:treatment_arm_id]
      stratum_id = params[:stratum_id]
      version = params[:version]
      @treatment_arm = TreatmentArm.find_by(treatment_arm_id, stratum_id, version, false).first
      error_message(Error.new('Resource Not Found')) if @treatment_arm.nil?
    end

    def set_latest_treatment_arm
      treatment_arm_id = params[:treatment_arm_id]
      stratum_id = params[:stratum_id]
      treatment_arms = TreatmentArm.find_treatment_arm(treatment_arm_id, stratum_id)
      @treatment_arm = treatment_arms.detect { |t| t.version == params[:version] }
      @treatment_arm = treatment_arms.sort { |x, y| y.date_created <=> x.date_created }.first unless @treatment_arm
    end

    def clone_params
      body_params = JSON.parse(request.raw_post)
      body_params.deep_transform_keys!(&:underscore).symbolize_keys!
      body_params[:version] = params[:version]
      [:treatment_arm_id, :stratum_id].each { |k| body_params.delete(k) }
      body_params[:stratum_id] = params[:stratum_id]
      body_params
    end

    def projection_params
      params[:projection] || [] if params[:projection].is_a?(Array)
    end

    def attribute_params
      params[:attribute] || [] if params[:attribute].is_a?(Array)
    end

    def filter_query(query_result)
      return [] if query_result.nil?
      [:treatment_arm_id, :stratum_id, :version, :active].each do |key|
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

    def params_to_boolean
      params.each do |key, value|
        if value == 'true'
          params[key] = true
        elsif value == 'false'
          params[key] = false
        end
      end
    end
  end
end
