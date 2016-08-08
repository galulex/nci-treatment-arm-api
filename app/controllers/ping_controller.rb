class PingController < ApplicationController
  before_action :authenticate

  def ping
    render status: 200
  end

end