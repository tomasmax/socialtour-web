class CreateSupercategoryRelations < ActiveRecord::Migration
  def change
    create_table :supercategory_relations do |t|
      t.integer :supercategory_minube_id
      t.string :supercategory_foursquare_id
      t.integer :supercategory_id

      t.timestamps
    end
  end
end
