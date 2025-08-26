if Rails.env.development?
  MenuItem.destroy_all
  Menu.destroy_all
end

lunch_menu = Menu.create!(name: "Lunch Menu")
dinner_menu = Menu.create!(name: "Dinner Menu")

lunch_menu.menu_items.create!([
  { name: "Classic Burger", price: 12.99 },
  { name: "Chicken Caesar Salad", price: 10.99 },
  { name: "Fish & Chips", price: 14.99 },
  { name: "Veggie Wrap", price: 9.99 }
])

dinner_menu.menu_items.create!([
  { name: "Ribeye Steak", price: 28.99 },
  { name: "Grilled Salmon", price: 22.99 },
  { name: "Pasta Carbonara", price: 16.99 },
  { name: "Roasted Chicken", price: 19.99 }
])

puts "Created #{Menu.count} menus with #{MenuItem.count} menu items total"
puts "Lunch Menu has #{lunch_menu.menu_items.count} items"
puts "Dinner Menu has #{dinner_menu.menu_items.count} items"
