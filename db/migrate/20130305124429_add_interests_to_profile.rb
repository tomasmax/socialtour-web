class AddInterestsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :born_date, :date
    add_column :profiles, :leisure, :integer, :default => 5
    add_column :profiles, :gastronomy, :integer, :default => 5
    add_column :profiles, :ferias, :integer, :default => 5
    add_column :profiles, :folclore, :integer, :default => 5
    add_column :profiles, :sport, :integer, :default => 5
    add_column :profiles, :nature, :integer, :default => 5
    add_column :profiles, :culture, :integer, :default => 5
    add_column :profiles, :other, :integer, :default => 5
    add_column :profiles, :buildings, :integer, :default => 5
    add_column :profiles, :friends, :integer, :default => 5
    add_column :profiles, :events, :integer, :default => 5
  end
end
