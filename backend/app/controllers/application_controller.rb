class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :set_security_headers

  private

  def set_security_headers
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    response.headers["Content-Security-Policy"] = "frame-ancestors 'none';"
  end

  def sanitized_params(permitted_params)
    permitted_params.transform_values do |value|
      value.is_a?(String) ? sanitize_html(value) : value
    end
  end

  def authenticate_admin
    authenticate_or_request_with_http_basic("Admin Area") do |username, password|
      username == admin_username && password == admin_password
    end
  end

  def admin_username
    ENV.fetch("ADMIN_USERNAME", "admin")
  end

  def admin_password
    ENV.fetch("ADMIN_PASSWORD", "password")
  end
end
