class CreateCategoryRelations < ActiveRecord::Migration
  def change
    create_table :category_relations do |t|
      t.integer :category_minube_id
      t.string :category_foursquare_id
      t.integer :category_id

      t.timestamps
    end
  end
end
