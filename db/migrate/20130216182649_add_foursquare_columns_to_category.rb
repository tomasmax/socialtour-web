class AddFoursquareColumnsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :foursquare_id, :string
    add_column :categories, :foursquare_icon, :string
    add_column :categories, :name_eu, :string
    add_column :categories, :name_en, :string
    add_column :categories, :icon_file_name, :string
    add_column :categories, :icon_content_type, :string
    add_column :categories, :icon_file_size, :integer
    add_column :categories, :icon_update_at, :datetime
  end
end
