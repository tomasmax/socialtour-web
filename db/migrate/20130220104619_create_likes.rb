class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :name
      t.string :category
      t.string :facebook_id
      t.datetime :created_time
      t.references :user

      t.timestamps
    end
  end
end
