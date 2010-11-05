class JsController < ApplicationController

  def index
    # Load params in local vars
    @emp_id  = params[:emp_id].to_i
    @week_no = params[:week_no].to_i
    @year    = params[:year].to_i

    # Sanity check for parameters
    if (!Employee.exists?(@emp_id))
      render :inline => 'Parameter error. Please check employee id'
      return
    end
    if (@week_no < 1) or (@week_no > 52) 
      render :inline => 'Parameter error. Please check week number is between 1-52'
      return
    end
    if (@year < 2000) or (@year > 2050)
      render :inline => 'Parameter error. Please check year is between 2000-2050'
      return
    end
    
    # We get the employee details
    @employee = Array.[]('employee_name : ' + session[:user_name], 'employee_id : ' + session[:user_id].to_s)

    # We get the text for the header
    @week_dates = Array.[]('week_text : ' + self.week_dates(@week_no, @year.to_s), 'week_number : ' + @week_no.to_s)

    # We get the list of all the projects
    @projects = self.get_projects(@emp_id, @week_no, @year)

    # We construct the output
    @out = Array.new
    @out << @employee 
    @out << @week_dates
    @projects.each do |p|
      @out << Array.[](p, p.jobs.find_all_by_employee_id(@emp_id))
    end

    render :inline => @out.to_json
    return 
  end

  # function that gets all the projects with the jobs for an employee
  #  in a certain week
  def get_projects(emp_id, week_no, year)
    begin
      emp_id  = emp_id.to_i
      week_no = week_no.to_i
      year    = year.to_i
      
      # Projects where the employee is a manager or partner
      p_partnerManager = Project.find_by_sql ["SELECT DISTINCT p.* FROM projects p WHERE partner_id = ? OR manager_id = ?", emp_id, emp_id]
  
      # Projects where the employee has a job assigned
      p_gotJobAssigned = Project.find_by_sql ["SELECT DISTINCT p.* FROM projects p, jobs j WHERE p.id=j.project_id AND j.employee_id=?", emp_id]
  
      # We merge the two into one, skipping duplicates
      projects = p_partnerManager | p_gotJobAssigned  
  
      # We filter the projects by date
      week_start = Date.commercial(year, week_no, 1)
      week_end   = Date.commercial(year, week_no, 5)
      projects.reject! {|p| p.date_start > week_end or p.date_end < week_start}

      return projects

    rescue Exception => e
      logger.error { "Error [js_controller.rb/get_projects] #{e.message}" }
    end
  end

  # function that receives a project and finds all the jobs
  #  assigned to the employee and includes them in the array
  def include_jobs_from_project(projects,emp_id)
    begin

      return output
    rescue Exception => e
      logger.error { "Error [js_controller.rb/include_jobs_from_project] #{e.message}" }
    end
  end

  def week_dates(week_num, year)
    begin
      week_start = Date.commercial(year.to_i, week_num.to_i, 1)
      week_end   = Date.commercial(year.to_i, week_num.to_i, 5)
      return week_start.strftime("%d %b %Y") + ' / ' + week_end.strftime("%d %b %Y")
    rescue Exception => e
      logger.error { "Error [js_controller.rb/week_dates] #{e.message}" }
    end
  end

end
