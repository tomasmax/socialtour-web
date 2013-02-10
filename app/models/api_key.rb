class ApiKey < ActiveRecord::Base
  attr_accessible :calls_count, :description, :key
end
