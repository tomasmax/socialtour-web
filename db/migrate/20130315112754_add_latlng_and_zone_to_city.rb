class AddLatlngAndZoneToCity < ActiveRecord::Migration
  def change
    add_column :cities, :latitude, :decimal
    add_column :cities, :longitude, :decimal
    add_column :cities, :zone, :references
  end
end
