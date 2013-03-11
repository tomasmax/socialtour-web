class CreateCategoryRelations < ActiveRecord::Migration
  def change
    create_table :category_relations do |t|
      t.integer :minube_id
      t.string :foursquare_id
      t.integer :my_category_id
      t.string :type

      t.timestamps
    end
  end
end
