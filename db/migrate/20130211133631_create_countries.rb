class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.integer :minube_id
      t.string :name
      t.integer :pois_count
      t.integer :full_count
      t.integer :see_count
      t.integer :restaurant_count
      t.integer :blog_count
      t.integer :hotel_count
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
