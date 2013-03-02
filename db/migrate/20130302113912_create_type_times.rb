class CreateTypeTimes < ActiveRecord::Migration
  def change
    create_table :type_times do |t|
      t.string :name
      t.time :time_from
      t.time :to_time
      t.datetime :date
      t.text :description

      t.timestamps
    end
  end
end
