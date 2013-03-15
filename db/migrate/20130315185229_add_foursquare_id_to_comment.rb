class AddFoursquareIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :foursquare_id, :string
  end
end
