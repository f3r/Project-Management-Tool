class HoursController < ApplicationController

  include ApplicationHelper
  include HoursHelper
  before_filter :protect_user
  
  # Shows the Hour Report form
  def index
    # We check if parameters are passed
    if params[:year].blank? || params[:week].blank?
      @year = (params[:year].blank?) ? Time.now.year.to_i : params[:year].to_i
      @week = (params[:week].blank?) ? Time.now.strftime("%W") : params[:week].to_i
      redirect_to url_for(:action => 'index', :year => @year.to_s, :week => @week.to_s, :escape => false)
      return
    end
    
    @year = params[:year].to_i
    @week = params[:week].to_i

    # We check if user can go to a certain date
    if start_date > Date.commercial(@year,@week, 1) or Date.commercial(@year,@week, 7) > Date.today
      @year = Time.now.year.to_i
      @week = Time.now.strftime("%W")
      redirect_to url_for(:action => 'index', :year => @year.to_s, :week => @week.to_s, :escape => false)
      return
    end
    
    @projects = get_projects(@year,@week)
  end
  
  def saveHours

      # We get all the jobs from
      params['job'].each do |job|
        saveWeekHoursForJob(params['year'],params['week'],job)
      end
            
      @year = Time.now.year.to_i
      @week = Time.now.strftime("%W")
      flash[:notice] = 'Hours successfully updated!'
      redirect_to url_for(:action => 'index', :year => @year.to_s, :week => @week.to_s, :escape => false)
      return
  end
  
private
  # function that gets all the projects with the jobs for an employee
  #  in a certain week
  def get_projects(year, week)
    begin
      emp_id = session[:user_id]
      week   = week
      year   = year
      
      # Projects where the employee is a manager or partner
      # p_partnerManager = Project.find_by_sql ["SELECT DISTINCT p.* FROM projects p WHERE partner_id = ? OR manager_id = ?", emp_id, emp_id]
  
      # Projects where the employee has a job assigned
      p_gotJobAssigned = Project.find_by_sql ["SELECT DISTINCT p.* FROM projects p, jobs j WHERE p.id=j.project_id AND j.employee_id=?", emp_id]
  
      # We merge the two into one, skipping duplicates
      #projects = p_partnerManager | p_gotJobAssigned  
  
      # We filter the projects by date
      week_start = Date.commercial(year, week, 1)
      week_end   = Date.commercial(year, week, 5)
      p_gotJobAssigned.reject! {|p| p.date_start > week_end or p.date_end < week_start}

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
        @job.week_hour.update_attributes(:h_mon => mon, :h_tue => tue, :h_wed => wed, :h_thu => thu, :h_fri => fri)
      end    
  end
end
