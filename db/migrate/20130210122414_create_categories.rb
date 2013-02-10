class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :supercategory
      t.string :group
      t.string :slug
      t.boolean :is_route
      t.text :description

      t.timestamps
    end
    add_index :categories, :supercategory_id
  end
end
