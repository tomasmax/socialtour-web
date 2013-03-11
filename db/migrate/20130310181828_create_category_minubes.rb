class CreateCategoryMinubes < ActiveRecord::Migration
  def change
    create_table :category_minubes do |t|
      t.references :supercategory_minube
      t.string :name
      t.string :group

      t.timestamps
    end
    add_index :category_minubes, :supercategory_minube_id
  end
end
