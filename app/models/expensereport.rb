class Expensereport < ActiveRecord::Base

  validates_numericality_of :amount
  
  belongs_to :projects
  belongs_to :employees
  belongs_to :jobs
end
