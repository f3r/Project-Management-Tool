class Expensereport < ActiveRecord::Base

  validates_numericality_of :amount
  validates_presence_of :project_id, :job_id, :amount, :expense_date
  
  belongs_to :project
  belongs_to :employee
  belongs_to :job

  def self.per_page
    DEFAULT_PER_PAGE
  end

end