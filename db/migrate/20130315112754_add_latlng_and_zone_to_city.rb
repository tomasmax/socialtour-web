class AddLatlngAndZoneToCity < ActiveRecord::Migration
  def change
    add_column :cities, :latitude, :decimal, :precision => 16, :scale => 8
    add_column :cities, :longitude, :decimal, :precision => 16, :scale => 8
    add_column :cities, :zone_id, :integer
  end
end
