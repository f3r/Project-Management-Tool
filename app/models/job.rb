class Job < ActiveRecord::Base
    # Validations
    validates_presence_of :name, :description, :project_id, :employee_id, :status

    # Relationships
    belongs_to  :employee
    belongs_to  :project
    has_many    :expensereports
    has_many    :week_hour, :class_name => 'WeekHours'
    belongs_to  :status

    def expenses
      return Expensereport.find_all_by_job_id(self.id).sum(&:amount)
    end
    
    def hours
      total = WeekHours.find_by_sql ["SELECT sum(h_mon + h_tue + h_wed + h_thu + h_fri) as total from week_hours WHERE job_id = ?", self.id]
      return total.first.total
    end
end