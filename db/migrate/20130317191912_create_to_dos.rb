class CreateToDos < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.string :user_id
      t.string :integer
      t.integer :poi_id
      t.integer :package_id
      t.integer :event_id
      t.text :comment

      t.timestamps
    end
  end
end
