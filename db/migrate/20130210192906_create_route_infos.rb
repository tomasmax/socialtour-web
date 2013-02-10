class CreateRouteInfos < ActiveRecord::Migration
  def change
    create_table :route_infos do |t|
      t.references :poi
      t.decimal :n_bound,                :precision => 16, :scale => 8
      t.decimal :s_bound,                :precision => 16, :scale => 8
      t.decimal :e_bound,                :precision => 16, :scale => 8
      t.decimal :w_bound,                :precision => 16, :scale => 8
      t.decimal :length,                 :precision => 8,  :scale => 2
      t.string  :difficulty
      t.decimal :max_elevation,          :precision => 6,  :scale => 2, :default => 0.0
      t.decimal :min_elevation,          :precision => 6,  :scale => 2, :default => 0.0
      t.decimal :max_up_slope,           :precision => 8,  :scale => 6, :default => 0.0
      t.decimal :max_down_slope,         :precision => 8,  :scale => 6, :default => 0.0
      t.decimal :accomulated_up_slope,   :precision => 10, :scale => 4, :default => 0.0
      t.decimal :accomulated_down_slope, :precision => 10, :scale => 4, :default => 0.0
      t.boolean :is_circular,                                           :default => false

      t.timestamps
    end
  end
end
