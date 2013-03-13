class CreateSupercategories < ActiveRecord::Migration
  def change
    create_table :supercategories do |t|
      t.string :name
      t.string :slug
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size
      t.datetime :icon_update_at
      t.string :group

      t.timestamps
    end
  end
end
