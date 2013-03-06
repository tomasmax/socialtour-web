class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment
      t.references :poi
      t.references :user
      t.references :package

      t.timestamps
    end
    add_index :comments, :poi_id
    add_index :comments, :user_id
    add_index :comments, :package_id
  end
end
