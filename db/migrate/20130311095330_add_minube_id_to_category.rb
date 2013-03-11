class AddMinubeIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :minube_id, :integer
  end
end
