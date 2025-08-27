class AddRestaurantToMenusWithData < ActiveRecord::Migration[8.0]
  def up
    add_reference :menus, :restaurant, null: true, foreign_key: true

    if Menu.exists?
      default_restaurant = Restaurant.create!(name: "Default Restaurant")
      Menu.update_all(restaurant_id: default_restaurant.id)
    end

    change_column_null :menus, :restaurant_id, false
  end

  def down
    remove_reference :menus, :restaurant, foreign_key: true
  end
end
