class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :picture
      t.string :url
      t.references :category
      t.string :supercategory
      t.string :references
      t.references :poi
      t.datetime :starts_at
      t.datetime :ends_at
      t.time :start_time
      t.decimal :price
      t.references :provider

      t.timestamps
    end
    add_index :events, :category_id
    add_index :events, :poi_id
    add_index :events, :provider_id
  end
end
