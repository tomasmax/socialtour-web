class AddTypesToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :type_leisure_id, :integer
    add_column :packages, :type_time_id, :integer
    add_column :packages, :type_vehicle_id, :integer
  end
end
