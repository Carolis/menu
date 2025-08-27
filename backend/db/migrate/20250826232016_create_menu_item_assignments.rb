class CreateMenuItemAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_item_assignments do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
