class AddMinubeIdToSupercategory < ActiveRecord::Migration
  def change
    add_column :supercategories, :minube_id, :integer
  end
end
