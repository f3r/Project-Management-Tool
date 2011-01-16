# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def is_user_logged?
      session[:user_id]    
  end
  
  def is_admin_logged?
      session[:is_admin?]
  end
  
  def menu_active? (cn)
      return (cn == controller.controller_name)
  end
  
  def protect_user
      unless is_user_logged?
          session[:protected_page] = request.request_uri
          flash[:notice] = "You must login first!"
          redirect_to :controller => 'site', :action => 'login'
          return false
      end
  end
  
  def protect_admin
      unless is_admin_logged?
          session[:protected_page] = request.request_uri
          flash[:error] = 'You must be admin to enter here!'
          redirect_to :controller => 'site', :action => 'login'
          return false
      end
  end
  
  def title(str, container = nil)
    @title = str
    content_tag(container, str) if container
  end

  def month_list(start_date,end_date)
    months = Array.new
    (start_date.year..end_date.year).each do |y|
       mo_start = (start_date.year == y) ? start_date.month : 1
       mo_end = (end_date.year == y) ? end_date.month : 12
       (mo_start..mo_end).each do |m|
           months << {:month => m, :year => y}
       end
    end
    return months.reverse
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end
  
  # PROJECTS STATS (THIS SHOULD BE CACHED)
  
  def jobs_count_from_projects(projects)
    jobs = 0
    for project in projects do
      jobs = jobs + project.number_of_jobs
    end
    return jobs
  end

  def total_expenses_from_projects(projects)
    expenses = 0
    for project in projects do
      expenses = expenses + project.accumulated_expenses
    end
    return expenses
  end

  def total_hours_from_projects(projects)
    hours = 0
    for project in projects do
      hours = hours + project.number_of_hours
    end
    return hours
  end

  def projects_by_status(projects, status_id)
    selected_projects = []
    for project in projects do
      if project.status_id == status_id
        selected_projects << project
      end
    end
    return selected_projects
  end

  def format_currency(money)
    number_to_currency(money, :unit => "&euro;", :separator => ",", :delimiter => ".", :format => "%n %u")
  end

end