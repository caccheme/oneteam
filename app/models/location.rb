class Location < ActiveRecord::Base
  attr_accessible :name

  has_many :employees
  has_many :requests
  
end