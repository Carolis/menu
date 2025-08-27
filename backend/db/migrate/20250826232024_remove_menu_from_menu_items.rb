class RemoveMenuFromMenuItems < ActiveRecord::Migration[8.0]
  def up
    MenuItem.find_each do |menu_item|
      if menu_item.menu_id.present?
        MenuItemAssignment.create!(
          menu_id: menu_item.menu_id,
          menu_item_id: menu_item.id
        )
      end
    end

    remove_reference :menu_items, :menu, null: false, foreign_key: true
  end

  def down
    add_reference :menu_items, :menu, null: true, foreign_key: true

    MenuItemAssignment.find_each do |assignment|
      MenuItem.find(assignment.menu_item_id).update!(menu_id: assignment.menu_id)
    end

    MenuItemAssignment.delete_all
  end
end
