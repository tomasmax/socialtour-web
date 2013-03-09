class AddEuskeraToEvent < ActiveRecord::Migration
  def change
    add_column :events, :name_eu, :string
    add_column :events, :description_eu, :text
  end
end
