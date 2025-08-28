class Api::V1::ImportsController < ApplicationController
  before_action :authenticate_admin

  def create
    begin
      if params[:file].present?
        result = import_from_file(params[:file])
      elsif params[:data].present?
        result = import_from_data(params[:data])
      else
        render json: { error: "No file or data provided" }, status: :bad_request
        return
      end

      if result[:success]
        render json: result, status: :created
      else
        render json: result, status: :unprocessable_content
      end
    rescue JSON::ParserError => e
      render json: {
        success: false,
        error: "Invalid JSON format",
        message: e.message
      }, status: :unprocessable_content
    rescue => e
      Rails.logger.error("Import controller error: #{e.message}")
      render json: {
        success: false,
        error: "Import failed",
        message: e.message
      }, status: :internal_server_error
    end
  end

  private

  def import_from_file(file)
    service = RestaurantImportService.new

    temp_file = Tempfile.new([ "restaurant_import", ".json" ])
    temp_file.write(file.read)
    temp_file.close

    result = service.import_from_file(temp_file.path)
    temp_file.unlink

    result
  end

  def import_from_data(data)
    service = RestaurantImportService.new
    json_data = data.is_a?(String) ? JSON.parse(data) : data
    service.import(json_data)
  end
end
