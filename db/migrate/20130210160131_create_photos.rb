class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :poi
      t.references :user
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.boolean :is_visible_on_index
      t.string :title
      t.string :subtitle
      t.string :title_eu
      t.string :subtitle_eu
      t.string :minube_url
      t.integer :sequence, :default =>0

      t.timestamps
    end
    add_index :photos, :poi_id
    add_index :photos, :user_id
  end
end
