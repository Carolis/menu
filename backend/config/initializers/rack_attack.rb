class Rack::Attack
  throttle("req/ip", limit: 100, period: 5.minutes) do |req|
    req.ip
  end

  throttle("imports/ip", limit: 5, period: 1.hour) do |req|
    req.ip if req.path.start_with?("/api/v1/import")
  end

  blocklist("block bad user agents") do |req|
    req.user_agent =~ /scanner|bot|crawler/i unless Rails.env.development?
  end

  throttle("api_key", limit: 1000, period: 1.hour) do |req|
    req.get_header("HTTP_X_API_KEY") if req.get_header("HTTP_X_API_KEY")
  end

  self.throttled_responder = lambda do |env|
    match_data = env["rack.attack.match_data"]
    retry_after = match_data.is_a?(Hash) ? match_data[:period] : 60
    retry_after ||= 60
    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [ { error: "Rate limit exceeded", retry_after: retry_after }.to_json ]
    ]
  end

  ActiveSupport::Notifications.subscribe("rack.attack") do |name, start, finish, request_id, payload|
    req = payload[:request]
    Rails.logger.warn "[RACK_ATTACK] #{req.ip} blocked: #{req.path}"
  end
end
