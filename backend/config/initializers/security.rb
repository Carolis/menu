Rails.application.config.force_ssl = true if Rails.env.production?

Rails.application.config.session_store :disabled

module SecurityHelpers
  def sanitize_html(text)
    return nil if text.blank?
    text.to_s.gsub(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/mi, "")
            .gsub(/<iframe\b[^<]*(?:(?!<\/iframe>)<[^<]*)*<\/iframe>/mi, "")
            .gsub(/javascript:/i, "")
            .gsub(/on\w+\s*=/i, "")
            .strip
  end

  def validate_json_structure(data, required_keys = [])
    return false unless data.is_a?(Hash)
    required_keys.all? { |key| data.key?(key) }
  end
end

ActiveSupport.on_load(:action_controller) do
  include SecurityHelpers
end
