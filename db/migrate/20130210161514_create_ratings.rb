class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :poi
      t.references :user
      t.references :package
      t.string :ip
      t.decimal :rating, :precision => 3, :scale => 1
      t.text :comment

      t.timestamps
    end
    add_index :ratings, :poi_id
    add_index :ratings, :user_id
  end
end
