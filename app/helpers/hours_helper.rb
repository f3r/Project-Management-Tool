module HoursHelper

  def show_date(year,week)
      out  = Date.commercial(year, week, 1).strftime("%e %b %Y") + ' - '
      out += Date.commercial(year, week, 5).strftime("%e %b %Y") + '&nbsp;'
      out += '<span>(Week ' + week.to_s + ')</span>'
      return out 
  end

  def url_for_next_week(year,week)
    if (week==52)
      year += 1
      week = 1
    else
      week += 1
    end
    return url_for(:action => 'index', :year => year.to_s, :week => week.to_s, :escape => false)
  end
  
  def url_for_prev_week(year,week)
    if (week==1)
      week = 52
      year -= 1
    else
      week -= 1
    end
    return url_for(:action => 'index', :year => year.to_s, :week => week.to_s, :escape => false)
  end
  
  def get_jobs(project)
    return project.jobs.find_all_by_employee_id(session[:user_id])
  end
  
  # Calculates the earliest starting date for the employee
  # We select all the projects that have a job assigned to the employee and return the earliest
  def start_date
    p = (Project.find_by_sql ["SELECT DISTINCT (p.date_start) FROM projects p, jobs j WHERE p.id=j.project_id AND j.employee_id=#{session[:user_id]}"])
    return (p.min { |a,b| a[:date_start] <=> b[:date_start] })["date_start"]
  end
  
  # If a float is .0, we return an int, otherwise return the float
  def ftoi(foo)
     return (foo.to_i == foo)? foo.to_i : foo
  end  
end
