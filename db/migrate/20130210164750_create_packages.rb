class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.references :category
      t.references :supercategory
      t.references :type_leisure
      t.references :type_time
      t.references :type_vehicle
      t.references :user
      t.references :provider
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_update_at

      t.timestamps
    end
    add_index :packages, :category_id
    add_index :packages, :supercategory_id
    add_index :packages, :type_id
    add_index :packages, :user_id
    add_index :packages, :provider_id
  end
end
