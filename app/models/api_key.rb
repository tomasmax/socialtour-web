class ApiKey < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  attr_accessible :calls_count, :description, :key
end
