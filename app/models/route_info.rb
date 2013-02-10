class RouteInfo < ActiveRecord::Base
  attr_accessible :accumulated_down_slope, :accumulated_up_slope, :difficulty, :e_bound, :is_circular, :lenght, :max_down_slope, :max_elevation, :min_elevation, :n_bound, :poi, :s_bound, :w_bound
end
