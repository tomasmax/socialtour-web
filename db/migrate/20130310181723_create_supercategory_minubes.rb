class CreateSupercategoryMinubes < ActiveRecord::Migration
  def change
    create_table :supercategory_minubes do |t|
      t.string :name

      t.timestamps
    end
  end
end
