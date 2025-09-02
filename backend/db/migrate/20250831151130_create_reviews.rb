class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :reviewer_name, null: false
      t.string :reviewer_email
      t.integer :rating, null: false
      t.text :comment
      t.timestamps
    end

    add_index :reviews, :rating
  end
end
