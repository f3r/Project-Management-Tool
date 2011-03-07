class Job < ActiveRecord::Base
    # Validations
    validates_presence_of :name, :description, :project_id, :employee_id, :status

    # Relationships
    belongs_to  :employee
    belongs_to  :project
    has_many    :expensereports, :dependent => :destroy
    has_many    :week_hour, :class_name => 'WeekHours', :dependent => :destroy
    belongs_to  :status

    def expenses
      return Expensereport.find_all_by_job_id(self.id).sum(&:amount)
    end
    
    def hours
      # we should cache this on the job table.
      total = WeekHours.find_by_sql ["SELECT sum(h_mon + h_tue + h_wed + h_thu + h_fri) as total from week_hours WHERE job_id = ?", self.id]
      if total.first.total.blank?
        return 0
      else 
        return total.first.total
      end
    end
    
    def total_billed
      return self.employee.category.hour_fee.to_i * self.hours.to_i
    end
end