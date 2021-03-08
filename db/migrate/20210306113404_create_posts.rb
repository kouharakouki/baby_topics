class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :product_name
      t.string :image_id
      t.integer :genre
      t.integer :price
      t.text :reason_for_selection
      t.text :good_point
      t.text :bad_point
      t.text :free_text
      t.integer :user_id

      t.timestamps
    end
  end
end
