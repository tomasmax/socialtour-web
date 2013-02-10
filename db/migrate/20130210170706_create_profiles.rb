class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.text :about_me
      t.text :i_like
      t.text :i_dont_like
      t.boolean :is_married
      t.boolean :has_sons
      t.string :restrictions

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end
