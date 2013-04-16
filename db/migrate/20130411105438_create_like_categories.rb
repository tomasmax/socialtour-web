class CreateLikeCategories < ActiveRecord::Migration
  def change
    create_table :like_categories do |t|
      t.integer :category_facebook_id
      t.integer :like_id

      t.timestamps
    end
  end
end
