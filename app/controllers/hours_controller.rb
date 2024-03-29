class HoursController < ApplicationController

  include ApplicationHelper
  include HoursHelper
  before_filter :protect_user
  
  # Shows the Hour Report form
  def index
    begin
      
      # We check if parameters are passed
      if params[:year].blank? || params[:week].blank?
        @year = (params[:year].blank?) ? Time.now.year           : params[:year]
        @week = (params[:week].blank?) ? Time.now.strftime("%W") : params[:week]
        redirect_to hoursreports_path(:year => @year.to_s, :week => @week.to_s, :escape => false)
        return
      end

      @year = params[:year].to_i
      @week = params[:week].to_i
            
      # If the date suplied is not a valid date
      if !Date.valid_commercial?(@year,@week,7)
        @year = Time.now.beginning_of_week.year
        @week = Time.now.beginning_of_week.strftime("%W")
        redirect_to hoursreports_path(:year => @year.to_s, :week => @week.to_s, :escape => false)
        return
      end
       
      # We check if user can go to a certain date
      # - Week starts before the first project
      # - Week ends later than today
      if Date.commercial(@year,@week, 1) < start_date  or Date.today < Date.commercial(@year,@week, 1)
        @year = Time.now.year.to_i
        @week = Time.now.strftime("%W").to_i
        redirect_to hoursreports_path(:year => @year.to_s, :week => @week.to_s, :escape => false)
        return
      end
      
      if params[:employee_id]
        user = params[:employee_id]
      else
        user = session[:user_id]
      end
      
      @projects = get_projects(@year,@week, user)

      if permitted_to? :manage, :projects
        @employees = Employee.find(:all, :order => "first_name ASC")
      elsif current_user.has_role?("manager")
        @employees = Employee.find_by_sql ["SELECT employees.* FROM employees LEFT OUTER JOIN jobs ON jobs.employee_id = employees.id INNER JOIN projects ON projects.id = jobs.project_id WHERE (projects.manager_id = ?)", session[:user_id]]
      end
      
      if @employees && params[:employee_id]
        employee = params[:employee_id]
        @employee = @employees.detect { |e| e.id == employee.to_i }
      end

    rescue Exception => e
      logger.error { "Error [hours_controller.rb/index] #{e.message}" }
    end
  end
  
  # Function that is called when user wants to SAVE or SIGN hours
  def saveHours
    begin
      # We check if the user wants to save data
      if params["commit"] == "Save"
        # We get all the jobs from the params and save all of them
        params['job'].each do |job|
          saveWeekHoursForJob(params['year'],params['week'],job)
        end

        respond_to do |format|
          format.html {
            flash[:notice] = 'Hours successfully updated!'
            redirect_to hoursreports_path(:year => params['year'], :week => params['week'], :escape => false)
          }
          format.js { @action = "saved" }
        end
        return

      elsif params["commit"] == "unsign"

        params['job'].each do |job|
          saveAndUnSignWeekHoursForJob(params['year'],params['week'],job)
        end

        respond_to do |format|
          format.html {
            flash[:notice] = 'Your report has been unsigned'
            redirect_to hoursreports_path(:year => params['year'], :week => params['week'], :escape => false)
          }
          format.js { @action = "unsigned" }
        end
        return
  
      # If the user wants to SIGN the report
      else
        # We get all the jobs from the jobs, and save+sign all of them
        params['job'].each do |job|
          saveAndSignWeekHoursForJob(params['year'],params['week'],job)
        end

        respond_to do |format|
          format.html {
            flash[:notice] = 'Your report has been signed'
            redirect_to hoursreports_path(:year => params['year'], :week => params['week'], :escape => false)
          }
          format.js { @action = "signed" }
        end
        return
      end
    rescue Exception => e
      logger.error { "Error [hours_controller.rb/saveHours] #{e.message}" }
    end
  end
  
private
  # function that gets all the projects with the jobs for an employee
  #  in a certain week
  def get_projects(year, week, employee_id)
    begin
      emp_id = employee_id
      week   = week
      year   = year
      
      # We filter the projects by date
      week_start = Date.commercial(year, week, 1)
      week_end   = Date.commercial(year, week, 5)

      # Projects where the employee is a manager or partner
      # p_partnerManager = Project.find_by_sql ["SELECT DISTINCT p.* FROM projects p WHERE partner_id = ? OR manager_id = ?", emp_id, emp_id]
  
      # Projects where the employee has a job assigned
      
      if permitted_to? :manage, :projects
        p_gotJobAssigned = Project.find(:all, :conditions => ["(jobs.employee_id = ? AND projects.date_start < ?) AND (projects.date_end > ? OR projects.status_id != ?)", emp_id, week_end, week_start, 3], :include => :jobs)
      elsif current_user.has_role?("manager") && emp_id != session[:user_id]
        p_gotJobAssigned = Project.find(:all, :conditions => ["(jobs.employee_id = ? AND projects.date_start < ?) AND (projects.date_end > ? OR projects.status_id != ?) AND projects.manager_id = ?", emp_id, week_end, week_start, 3, session[:user_id]], :include => :jobs)
      else
        p_gotJobAssigned = Project.find(:all, :conditions => ["(jobs.employee_id = ? AND projects.date_start < ?) AND (projects.date_end > ? OR projects.status_id != ?)", emp_id, week_end, week_start, 3], :include => :jobs)
      end
  
      # We merge the two into one, skipping duplicates
      #projects = p_partnerManager | p_gotJobAssigned  
  

      return p_gotJobAssigned

    rescue Exception => e
      logger.error { "Error [hours_controller.rb/get_projects] #{e.message}" }
    end
  end  

  def saveWeekHoursForJob(year,week,jobArray)
      @job  = Job.find(jobArray[0])
      
      # parse params
      mon = jobArray[1]['mon'].to_i
      tue = jobArray[1]['tue'].to_i
      wed = jobArray[1]['wed'].to_i
      thu = jobArray[1]['thu'].to_i
      fri = jobArray[1]['fri'].to_i

      @hours = @job.week_hour.find(:first, :conditions => { :year => year, :week => week })

      # If there are no hours associated with this job in this week,year
      if @hours.blank?
        # create hours
        @job.week_hour.create(:year => year, :week => week, :h_mon => mon, :h_tue => tue, 
                              :h_wed => wed, :h_thu => thu, :h_fri => fri, :signed => false)
      else
        # update attributes with new hours
        @hours.update_attributes(:h_mon => mon, :h_tue => tue, :h_wed => wed, :h_thu => thu, :h_fri => fri)
      end    
  end
  
  def saveAndSignWeekHoursForJob(year,week,jobArray)
      @job  = Job.find(jobArray[0])
      
      # parse params
      mon = jobArray[1]['mon'].to_i
      tue = jobArray[1]['tue'].to_i
      wed = jobArray[1]['wed'].to_i
      thu = jobArray[1]['thu'].to_i
      fri = jobArray[1]['fri'].to_i

      @hours = @job.week_hour.find(:first, :conditions => { :year => year, :week => week })

      # If there are no hours associated with this job in this week,year
      if @hours.blank?
        # create hours
        @job.week_hour.create(:year => year, :week => week, :h_mon => mon, :h_tue => tue, 
                              :h_wed => wed, :h_thu => thu, :h_fri => fri, :signed => true)
      else
        # update attributes with new hours
        @hours.update_attributes(:h_mon => mon, :h_tue => tue, :h_wed => wed, :h_thu => thu, :h_fri => fri, :signed => true)
      end    
  end  

  def saveAndUnSignWeekHoursForJob(year,week,jobArray)
      @job  = Job.find(jobArray[0])
      
      # parse params
      mon = jobArray[1]['mon'].to_i
      tue = jobArray[1]['tue'].to_i
      wed = jobArray[1]['wed'].to_i
      thu = jobArray[1]['thu'].to_i
      fri = jobArray[1]['fri'].to_i

      @hours = @job.week_hour.find(:first, :conditions => { :year => year, :week => week })

      # If there are no hours associated with this job in this week,year
      if @hours.blank?
        # create hours
        @job.week_hour.create(:year => year, :week => week, :h_mon => mon, :h_tue => tue, 
                              :h_wed => wed, :h_thu => thu, :h_fri => fri, :signed => false)
      else
        # update attributes with new hours
        @hours.update_attributes(:h_mon => mon, :h_tue => tue, :h_wed => wed, :h_thu => thu, :h_fri => fri, :signed => false)
      end    
  end  

end
