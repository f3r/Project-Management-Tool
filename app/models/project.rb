class Project < ActiveRecord::Base
    using_access_control

    # Validations
    validates_presence_of :name, :description, :status, :partner_id, :manager_id, :client_id
    validates_date :date_start, :on_or_after => lambda { 1.years.ago }
    validates_date :date_end, :on_or_after => :date_start

    # Relationships
    belongs_to  :partner, :class_name => 'Employee', :foreign_key => 'partner_id'
    belongs_to  :manager, :class_name => 'Employee', :foreign_key => 'manager_id'
    belongs_to  :client
    belongs_to  :status
    has_many    :jobs, :dependent => :destroy
    has_many    :expensereports

    def self.per_page
      DEFAULT_PER_PAGE
    end
    
    def self.create_project(params)
      begin
          project = Project.new(params)
          project.save
          return project
      rescue Exception => e
          logger.error { "Error [project.rb/create_project] #{e.message}" }
      end        
    end
    
    def number_of_jobs
      begin
          self.jobs.count
      rescue Exception => e
        logger.error { "Error [project.rb/number_of_jobs] #{e.message}" }
      end
    end
    
    def number_of_hours
      # ES RECOMENDABLE HACER UN CACHE DE ESTO.
      begin
        hours = 0
        for job in self.jobs do
          hours = hours + job.hours.to_i
        end
        return hours
      rescue Exception => e
        logger.error { "Error [project.rb/number_of_hours] #{e.message}" }
      end
    end
    
    def accumulated_expenses
      begin
        self.expensereports.to_a.sum(&:amount)
      rescue Exception => e
        logger.error { "Error [project.rb/accumulated_expenses] #{e.message}" }
      end
    end

    def total_billed
      # ES RECOMENDABLE HACER UN CACHE DE ESTO.
      begin
        total = 0
        for job in self.jobs do
          total = total + job.total_billed
        end
        return total
      rescue Exception => e
        logger.error { "Error [project.rb/total_billed] #{e.message}" }
      end
    end

    def has_pending_jobs?
      begin
        jobs = self.jobs.find(:all, :conditions => ["jobs.status_id != ?", 3])
        return jobs.count > 0
      rescue Exception => e
        logger.error { "Error [project.rb/has_pending_jobs?] #{e.message}" }
      end
    end
    
    def remaining_days
      unless self.date_end.blank?
        remaining_days = self.date_end.to_datetime - Time.now.to_date
        return remaining_days
      else
        return 0
      end
    end
    
    def involved_employees
      begin
        employee_list = Job.find_by_sql ["SELECT DISTINCT employee_id from jobs WHERE project_id = ?", self.id]
        employees = employee_list.map {|p| p.employee_id.to_i }
        # for employee in self.client.employee_clients
        #   employees << employee.employee_id.to_i
        # end
        employees << self.partner_id
        employees << self.manager_id
        return employees.uniq
      rescue Exception => e
        logger.error { "Error [project.rb/involved_employees] #{e.message}" }
      end
    end

    # def managers
    #   begin
    #     employees = []
    #     for employee in self.client.employee_clients
    #       employees << employee.employee_id.to_i
    #     end
    #     employees << self.manager_id
    #     return employees
    #   rescue Exception => e
    #     logger.error { "Error [project.rb/managers] #{e.message}" }
    #   end
    # end
  
end
