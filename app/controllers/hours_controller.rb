class HoursController < ApplicationController

  include ApplicationHelper
  before_filter :protect_user
  
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
    
    @projects = get_projects(@year,@week)
  end
  
private
  # function that gets all the projects with the jobs for an employee
  #  in a certain week
  def get_projects(year, week)
    begin
      emp_id  = session[:user_id]
      week = week
      year    = year
      
      # Projects where the employee is a manager or partner
      p_partnerManager = Project.find_by_sql ["SELECT DISTINCT p.* FROM projects p WHERE partner_id = ? OR manager_id = ?", emp_id, emp_id]
  
      # Projects where the employee has a job assigned
      p_gotJobAssigned = Project.find_by_sql ["SELECT DISTINCT p.* FROM projects p, jobs j WHERE p.id=j.project_id AND j.employee_id=?", emp_id]
  
      # We merge the two into one, skipping duplicates
      projects = p_partnerManager | p_gotJobAssigned  
  
      # We filter the projects by date
      week_start = Date.commercial(year, week, 1)
      week_end   = Date.commercial(year, week, 5)
      projects.reject! {|p| p.date_start > week_end or p.date_end < week_start}

      return projects

    rescue Exception => e
      logger.error { "Error [hours_controller.rb/get_projects] #{e.message}" }
    end
  end  
end
