class Expensereport < ActiveRecord::Base
  # include ActiveRecord::Validations

  validates_numericality_of :amount
  validates_presence_of :project_id, :job_id, :amount, :expense_date, :expense_category_id
  validates_date :expense_date, :on_or_after => :project_date_start
  validates_date :expense_date, :on_or_before => :project_date_end

  attr_accessor :project_date_start, :project_date_end
  
  belongs_to :project
  belongs_to :employee
  belongs_to :job
  belongs_to :expense_category

  def self.per_page
    DEFAULT_PER_PAGE
  end

end