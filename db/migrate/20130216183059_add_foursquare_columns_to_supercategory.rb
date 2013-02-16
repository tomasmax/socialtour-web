class AddFoursquareColumnsToSupercategory < ActiveRecord::Migration
  def change
    add_column :supercategories, :foursquare_id, :string
    add_column :supercategories, :foursquare_icon, :string
    add_column :supercategories, :name_eu, :string
    add_column :supercategories, :name_en, :string
  end
end
