class CreateCategoryFacebooks < ActiveRecord::Migration
  def change
    create_table :category_facebooks do |t|
      t.string :name

      t.timestamps
    end
  end
end
