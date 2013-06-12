class CreatePackagePois < ActiveRecord::Migration
  def change
    create_table :package_pois do |t|
      t.references :package
      t.references :poi

      t.timestamps
    end
    add_index :package_pois, :package_id
    add_index :package_pois, :poi_id
  end
end
