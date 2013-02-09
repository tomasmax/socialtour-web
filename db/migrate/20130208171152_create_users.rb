class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.references :city

      t.timestamps
    end
    add_index :users, :city_id
  end
end
