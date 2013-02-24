class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :type
      t.text :description

      t.timestamps
    end
  end
end
