class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.string :name
      t.string :name_en
      t.string :name_eu
      t.references :category
      t.string :group
      t.string :slug
      t.boolean :is_route
      t.text :description
      t.string :foursquare_id
      t.string :foursquare_icon
      t.string :name_eu
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size
      t.datetime :icon_update_at

      t.timestamps
    end
    add_index :categories, :supercategory_id
  end
end
