class AddInterestsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :leisure, :integer
    add_column :profiles, :gastronomy, :integer
    add_column :profiles, :ferias, :integer
    add_column :profiles, :foloclore, :integer
    add_column :profiles, :sport, :integer
    add_column :profiles, :nature, :integer
    add_column :profiles, :culture, :string
    add_column :profiles, :integer, :string
    add_column :profiles, :other, :integer
    add_column :profiles, :buildings, :integer
    add_column :profiles, :friends, :integer
    add_column :profiles, :events, :integer
  end
end
