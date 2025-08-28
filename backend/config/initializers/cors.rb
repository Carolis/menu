Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      origins "http://localhost:5173"
    else
      allowed_origins = [
        "https://menu-frontend-production.up.railway.app",
        ENV["FRONTEND_URL"]
      ].compact.uniq

      raise "No production frontend origins configured" if allowed_origins.empty?

      origins allowed_origins
    end
    resource "*", headers: :any, methods: [ :get, :post, :patch, :put, :delete, :options ]
  end
end
