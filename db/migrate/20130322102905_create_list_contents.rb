class CreateListContents < ActiveRecord::Migration
  def change
    create_table :list_contents do |t|
      t.references :list
      t.references :poi
      t.references :package
      t.references :event

      t.timestamps
    end
    add_index :list_contents, :list_id
    add_index :list_contents, :poi_id
    add_index :list_contents, :package_id
    add_index :list_contents, :event_id
  end
end
