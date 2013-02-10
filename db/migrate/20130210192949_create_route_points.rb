class CreateRoutePoints < ActiveRecord::Migration
  def change
    create_table :route_points do |t|
      t.references :poi
      t.decimal :latitude,  :precision => 16, :scale => 8
      t.decimal :longitude, :precision => 16, :scale => 8
      t.decimal :elevation, :precision => 6,  :scale => 2, :default => 0.0


      t.timestamps
    end
    add_index :route_points, :poi_id
  end
end
