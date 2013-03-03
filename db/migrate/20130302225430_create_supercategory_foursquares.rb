class CreateSupercategoryFoursquares < ActiveRecord::Migration
  def change
    create_table :supercategory_foursquares do |t|
      t.string :name
      t.string :name_en
      t.string :pluralName
      t.string :shortName
      t.string :foursquare_id
      t.string :foursquare_icon

      t.timestamps
    end
  end
end
