class AddFoursquareUrlToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :foursquare_url, :string
  end
end
