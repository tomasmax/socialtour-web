class AddFoursquareColumnsToPoi < ActiveRecord::Migration
  def change
    add_column :pois, :foursquare_id, :string
    add_column :pois, :foursquare_url, :string
    add_column :pois, :checkins_count, :integer
    add_column :pois, :users_count, :integer
    add_column :pois, :tip_count, :string
    add_column :pois, :likes_count, :integer
  end
end
