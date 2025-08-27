if Rails.env.development?
  MenuItemAssignment.destroy_all
  MenuItem.destroy_all
  Menu.destroy_all
  Restaurant.destroy_all
end

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

puts "Created #{Restaurant.count} restaurants"
puts "Created #{Menu.count} menus"
puts "Created #{MenuItem.count} unique menu items"
puts "Created #{MenuItemAssignment.count} menu item assignments"

puts "\nRestaurant breakdown:"
Restaurant.includes(menus: :menu_items).each do |restaurant|
  puts "#{restaurant.name}: #{restaurant.menus.count} menus, #{restaurant.menu_items.distinct.count} unique items"
  restaurant.menus.each do |menu|
    puts "  - #{menu.name}: #{menu.menu_items.count} items"
  end
end

puts "\nDemonstrating Level 2 requirements:"
puts "MenuItem '#{burger.name}' appears on #{burger.menus.count} menus across #{burger.restaurants.distinct.count} restaurants"
puts "All MenuItem names are unique: #{MenuItem.pluck(:name).uniq.count} == #{MenuItem.count}"
