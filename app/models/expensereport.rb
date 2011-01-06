class Expensereport < ActiveRecord::Base

  validates_numericality_of :amount
  validates_presence_of :project_id, :job_id, :amount, :expense_date
  validates_date :expense_date, :on_or_after => lambda { 1.years.ago }
  
  belongs_to :project
  belongs_to :employee
  belongs_to :job
  belongs_to :expense_category

  def self.per_page
    DEFAULT_PER_PAGE
  end

end