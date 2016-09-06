# TreatmentArms Controller which handles all the API calls for the
# TreatmentArm Ecosystem
 module Api
   module V1
     class TreatmentArmsController < ApplicationController
       include HTTParty
       # before_action :authenticate, if: "Rails.env.production?"
       before_action :set_treatment_arms, only: ['index']
       before_action :set_treatment_arm, only: %w(show update_clone)

       def create
         begin
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
         rescue => error
           standard_error_message(error)
         end
       end

       def index
         begin
           if @basic_serializer == true
             render json: @treatment_arms, each_serializer: ::TreatmentArmBasicSerializer
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
             # Work around as we are unable pass options to active model serializer
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
           Aws::Publisher.publish(treatment_arm: @treatment_arm.clone_attributes.merge!(clone_params))
           render json: { message: 'Message has been processed successfully' }, status: 200
         rescue => error
           standard_error_message(error)
         end
       end

       private

       def set_treatment_arms
         params[:is_active_flag] = params[:active]
         if params[:basic].present?
           @basic_serializer = params[:basic].downcase == 'true' ? true : false
         end
         @treatment_arms = filter_query(TreatmentArm.all.entries)
       end

       def set_treatment_arm
         @treatment_arm = filter_query(TreatmentArm.where(name: params[:id]).entries).first
         # standard_error_message("Unable to find treatment_arm with given details") if @treatment_arm.nil?
       end

       def clone_params
         params.require(:treatment_arm).permit(:version)
       end

       def filter_query(query_result)
         return [] if query_result.nil?
         [:name, :stratum_id, :version, :is_active_flag].each do |key|
           if params[key].present?
             new_query_result = query_result.select{ |t| t.send(key) == params[key] }
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
