class RestaurantImportService
  include ActiveModel::Model

  def initialize
    @logs = []
    @errors = []
    @stats = {
      restaurants_created: 0,
      menus_created: 0,
      menu_items_created: 0,
      menu_items_assigned: 0,
      duplicates_skipped: 0
    }
  end

  def import_from_file(file_path)
    begin
      unless File.exist?(file_path)
        return error_result("File not found: #{file_path}")
      end

      json_data = JSON.parse(File.read(file_path))
      import(json_data)
    rescue JSON::ParserError => e
      error_result("Invalid JSON format: #{e.message}")
    rescue => e
      error_result("Import failed: #{e.message}")
    end
  end

  def import(json_data)
    @logs.clear
    @errors.clear
    reset_stats

    begin
      ActiveRecord::Base.transaction do
        import_restaurants(json_data["restaurants"] || [])

        if @errors.any?
          raise ActiveRecord::Rollback, "Import failed due to validation errors"
        end
      end

      if @errors.any?
        return error_result("Import failed with errors")
      end

      success_result
    rescue ActiveRecord::Rollback
      error_result("Import failed due to validation errors")
    rescue => e
      Rails.logger.error("Import failed: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      error_result("Import failed: #{e.message}")
    end
  end

  private

  def import_restaurants(restaurants_data)
    restaurants_data.each do |restaurant_data|
      import_restaurant(restaurant_data)
    end
  end

  def import_restaurant(restaurant_data)
    restaurant_name = restaurant_data["name"]&.strip

    if restaurant_name.blank?
      @errors << "Restaurant name is required"
      return
    end

    restaurant = Restaurant.find_or_create_by(name: restaurant_name) do |r|
      @stats[:restaurants_created] += 1
      log_info("Created restaurant: #{restaurant_name}")
    end

    if restaurant.persisted?
      import_menus(restaurant, restaurant_data["menus"] || [])
    else
      @errors << "Failed to create restaurant: #{restaurant.errors.full_messages.join(', ')}"
    end
  end

  def import_menus(restaurant, menus_data)
    menus_data.each do |menu_data|
      import_menu(restaurant, menu_data)
    end
  end

  def import_menu(restaurant, menu_data)
    menu_name = menu_data["name"]&.strip

    if menu_name.blank?
      log_warning("Skipping menu without name for restaurant #{restaurant.name}")
      return
    end

    menu = restaurant.menus.find_or_create_by(name: menu_name) do |m|
      @stats[:menus_created] += 1
      log_info("Created menu: #{menu_name} for #{restaurant.name}")
    end

    if menu.persisted?
      items_data = menu_data["menu_items"] || menu_data["dishes"] || []
      import_menu_items(menu, items_data)
    else
      @errors << "Failed to create menu #{menu_name}: #{menu.errors.full_messages.join(', ')}"
    end
  end

  def import_menu_items(menu, items_data)
    processed_items = Set.new

    items_data.each do |item_data|
      item_name = item_data["name"]&.strip
      price = item_data["price"]

      if item_name.blank?
        log_warning("Skipping menu item without name")
        next
      end

      unless valid_price?(price)
        @errors << "Invalid price for #{item_name}: #{price}"
        next
      end

      item_key = "#{item_name}_#{price}"
      if processed_items.include?(item_key)
        @stats[:duplicates_skipped] += 1
        log_duplicate("Skipping duplicate item in menu #{menu.name}: #{item_name} ($#{price})")
        next
      end
      processed_items.add(item_key)

      import_menu_item(menu, item_name, price)
    end
  end

  def import_menu_item(menu, item_name, price)
    menu_item = MenuItem.find_or_create_by(name: item_name) do |mi|
      mi.price = price
      @stats[:menu_items_created] += 1
      log_info("Created menu item: #{item_name} ($#{price})")
    end

    unless menu_item.persisted?
      @errors << "Failed to create menu item #{item_name}: #{menu_item.errors.full_messages.join(', ')}"
      return
    end

    if menu_item.price.to_f != price.to_f
      old_price = menu_item.price
      menu_item.update!(price: price)
      log_info("Updated price for #{item_name}: $#{old_price} -> $#{price}")
    end

    unless menu.menu_items.include?(menu_item)
      menu.menu_items << menu_item
      @stats[:menu_items_assigned] += 1
      log_info("Assigned #{item_name} to menu #{menu.name}")
    else
      log_duplicate("Item #{item_name} already on menu #{menu.name}")
    end
  end

  def valid_price?(price)
    return false if price.nil?
    return false unless price.is_a?(Numeric) || (price.is_a?(String) && price.match?(/^\d*\.?\d+$/))
    price.to_f >= 0
  end

  def log_info(message)
    @logs << { type: "info", message: message, timestamp: Time.current }
    Rails.logger.info("[RestaurantImport] #{message}")
  end

  def log_warning(message)
    @logs << { type: "warning", message: message, timestamp: Time.current }
    Rails.logger.warn("[RestaurantImport] #{message}")
  end

  def log_error(message)
    @logs << { type: "error", message: message, timestamp: Time.current }
    Rails.logger.error("[RestaurantImport] #{message}")
  end

  def log_duplicate(message)
    @logs << { type: "duplicate", message: message, timestamp: Time.current }
    Rails.logger.info("[RestaurantImport] #{message}")
  end

  def reset_stats
    @stats.each_key { |key| @stats[key] = 0 }
  end

  def success_result
    {
      success: true,
      logs: @logs,
      summary: @stats,
      message: "Import completed successfully"
    }
  end

  def error_result(message)
    {
      success: false,
      logs: @logs,
      errors: @errors + [ message ],
      summary: @stats
    }
  end
end
