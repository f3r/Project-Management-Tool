class Expensereport < ActiveRecord::Base

  validates_numericality_of :amount
  validates_presence_of :project_id, :job_id, :amount, :expenseDate
  
  belongs_to :project
  belongs_to :employee
  belongs_to :job
end
