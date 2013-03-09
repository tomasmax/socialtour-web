class AddCityAndlatlngToEvent < ActiveRecord::Migration
  def change
    add_column :events, :city_id, :integer
    add_column :events, :latitude, :decimal, :precision => 16, :scale => 8
    add_column :events, :longitude, :decimal, :precision => 16, :scale => 8
  end
end
