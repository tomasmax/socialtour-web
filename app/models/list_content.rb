class ListContent < ActiveRecord::Base
  belongs_to :list
  belongs_to :poi
  belongs_to :package
  belongs_to :event
  # attr_accessible :title, :body
end
