class RemoveTypeFromPackage < ActiveRecord::Migration
  def up
    remove_column :packages, :type_id, :integer
  end

  def down
    
  end
end
