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
    has_many    :expensereports, :dependent => :destroy

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
    
    def weeks

      start_date = self.date_start
      if self.date_end > Date.today or self.remaining_days < 0
        end_date = Date.today
      else
        end_date = self.date_end
      end
      
      start_week  = [start_date.beginning_of_week.year,start_date.cweek]
      end_week  = [end_date.year,end_date.cweek]

      weeks = []
      week = start_week[1]
      year = start_week[0]

      begin        
        begin
          if week == 53
            week = 1
          end
          weeks << [year,week]
          week += 1
          if year < end_week[0]
            final_week = 52
          else
            final_week = end_week[1]
          end
        end while week <= final_week        
        year += 1
      end while (year <= end_week[0])

      return weeks
    end
    
    def employees_hours(weeks)
      employees = Employee.find(:all, :conditions => ["jobs.project_id = ?", self.id], :include => :jobs)
      hours = []
      for employee in employees
        employee_hours = []

        for week in weeks
          employee_hours << self.week_hours_per_employee(week[0],week[1],employee.id)
        end

        hours << { :name => employee.full_name, :data => employee_hours }
      end
      return hours.to_json
    end
  
    def week_hours_per_employee(year,week,employee_id)
      hours = WeekHours.find_by_sql ["SELECT sum(week_hours.h_mon + week_hours.h_tue + week_hours.h_wed + week_hours.h_thu + week_hours.h_fri) AS hours_in_week FROM week_hours LEFT OUTER JOIN jobs ON jobs.id = week_hours.job_id WHERE (week_hours.year = ? AND week_hours.week = ? AND jobs.project_id = ? AND jobs.employee_id = ?)", year, week, self.id, employee_id]
      return hours.first.hours_in_week.to_i
    end
    
end
