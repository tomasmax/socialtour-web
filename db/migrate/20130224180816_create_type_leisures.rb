class CreateTypeLeisures < ActiveRecord::Migration
  def change
    create_table :type_leisures do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
