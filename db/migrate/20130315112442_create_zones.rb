class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.references :country

      t.timestamps
    end
    add_index :zones, :country_id
  end
end
