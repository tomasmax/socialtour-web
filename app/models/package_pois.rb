class PackagePois < ActiveRecord::Base
  belongs_to :poi
  belongs_to :package

  accepts_nested_attributes_for :poi, :reject_if => :all_blank
end
