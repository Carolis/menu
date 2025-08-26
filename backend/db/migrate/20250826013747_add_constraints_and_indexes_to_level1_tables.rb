class AddConstraintsAndIndexesToLevel1Tables < ActiveRecord::Migration[8.0]
  def change
    change_column_null :menus, :name, false
    change_column_null :menu_items, :name, false
    change_column_null :menu_items, :price, false

    change_column :menu_items, :price, :decimal, precision: 8, scale: 2

    add_index :menus, :name unless index_exists?(:menus, :name)
    add_index :menu_items, :name unless index_exists?(:menu_items, :name)

    add_index :menu_items, :menu_id unless index_exists?(:menu_items, :menu_id)
  end
end
