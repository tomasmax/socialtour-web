class ToDo < ActiveRecord::Base
  attr_accessible :comment, :event_id, :integer, :package_id, :poi_id, :user_id
end
