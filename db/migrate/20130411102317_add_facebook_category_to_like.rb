class AddFacebookCategoryToLike < ActiveRecord::Migration
  def change
    add_column :likes, :category_facebook_id, :integer
  end
end
