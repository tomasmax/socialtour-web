class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.text :description
      t.references :city
      t.references :category
      t.references :supercategory

      t.timestamps
    end
    add_index :providers, :city_id
    add_index :providers, :category_id
    add_index :providers, :supercategory_id
  end
end
