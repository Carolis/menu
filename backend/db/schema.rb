# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_31_151130) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "menu_item_assignments", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.bigint "menu_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "menu_id" ], name: "index_menu_item_assignments_on_menu_id"
    t.index [ "menu_item_id" ], name: "index_menu_item_assignments_on_menu_item_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "name" ], name: "index_menu_items_on_name"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "restaurant_id", null: false
    t.index [ "name" ], name: "index_menus_on_name"
    t.index [ "restaurant_id" ], name: "index_menus_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.string "reviewer_name", null: false
    t.string "reviewer_email", null: false
    t.integer "rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "rating" ], name: "index_reviews_on_rating"
    t.index [ "restaurant_id" ], name: "index_reviews_on_restaurant_id"
  end

  add_foreign_key "menu_item_assignments", "menu_items"
  add_foreign_key "menu_item_assignments", "menus"
  add_foreign_key "menus", "restaurants"
  add_foreign_key "reviews", "restaurants"
end
