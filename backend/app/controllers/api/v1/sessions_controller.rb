class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_admin

  def verify
    render json: { authenticated: true, message: "Authentication successful" }
  end
end
