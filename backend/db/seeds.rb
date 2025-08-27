if Rails.env.development?
  MenuItemAssignment.destroy_all
  MenuItem.destroy_all
  Menu.destroy_all
  Restaurant.destroy_all
end

json_file = Rails.root.join('db', 'restaurant_data.json')
if File.exist?(json_file)
  puts "Importing from restaurant_data.json..."
  service = RestaurantImportService.new
  result = service.import_from_file(json_file.to_s)

  if result[:success]
    puts "JSON import successful"
    puts "Summary: #{result[:summary]}"
  else
    puts "JSON import failed: #{result[:errors].join(', ')}"
  end
else
  puts "Creating seed data manually"

  poppys_cafe = Restaurant.create!(name: "Poppo's Cafe")
  casa_del_poppo = Restaurant.create!(name: "Casa del Poppo")

  poppy_lunch = poppys_cafe.menus.create!(name: "lunch")
  poppy_dinner = poppys_cafe.menus.create!(name: "dinner")
  casa_lunch = casa_del_poppo.menus.create!(name: "lunch")
  casa_dinner = casa_del_poppo.menus.create!(name: "dinner")

  burger = MenuItem.create!(name: "Burger", price: 12.99)
  small_salad = MenuItem.create!(name: "Small Salad", price: 5.00)
  large_salad = MenuItem.create!(name: "Large Salad", price: 8.00)
  chicken_wings = MenuItem.create!(name: "Chicken Wings", price: 9.00)
  mega_burger = MenuItem.create!(name: "Mega Burger", price: 22.00)
  lobster_mac = MenuItem.create!(name: "Lobster Mac & Cheese", price: 31.00)

  poppy_lunch.menu_items << [ burger, small_salad ]
  poppy_dinner.menu_items << [ burger, large_salad ]
  casa_lunch.menu_items << [ chicken_wings, burger ]
  casa_dinner.menu_items << [ mega_burger, lobster_mac ]
end

puts "database seeded sucessfully"
puts "  Restaurants: #{Restaurant.count}"
puts "  Menus: #{Menu.count}"
puts "  Menu Items: #{MenuItem.count}"
