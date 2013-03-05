class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.string :name
      t.text :description
      t.decimal :latitude, :precision => 16, :scale => 8
      t.decimal :longitude, :precision => 16, :scale => 8
      t.references :user
      t.integer :ratings_count, :default => 0
      t.decimal :rating, :precision => 3,  :scale => 1, :default => 0.0
      t.string :slug
      t.string :address
      t.string :telephone
      t.string :website
      t.string :minube_url
      t.string :minube_id
      t.references :city
      t.references :category
      t.references :supercategory
      t.string :name_eu
      t.text :description_eu
      t.text :timetable

      t.timestamps
    end
    add_index :pois, :user_id
    add_index :pois, :city_id
    add_index :pois, :category_id
    add_index :pois, :supercategory_id
  end
end
