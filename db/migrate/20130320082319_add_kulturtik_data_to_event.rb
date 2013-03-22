class AddKulturtikDataToEvent < ActiveRecord::Migration
  def change
    add_column :events, :timetable, :text
    add_column :events, :place, :string
    add_column :events, :buy_ticket_url, :string
  end
end
