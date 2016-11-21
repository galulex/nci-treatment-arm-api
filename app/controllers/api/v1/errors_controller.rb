module Api
  module V1
    class ErrorsController < ApplicationController

      def render_not_found
        respond_to do |format|
          format.json { render json: { message: "No Route matches /api/v1/#{params[:path]}" }, layout: false, status: :bad_request }
          format.any { head :not_acceptable }
        end
      end

    end
  end
end