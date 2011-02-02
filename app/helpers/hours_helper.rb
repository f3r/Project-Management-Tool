module HoursHelper

  def show_date(year,week)
      out  = Date.commercial(year, week, 1).strftime("%e %b %Y") + ' - '
      out += Date.commercial(year, week, 5).strftime("%e %b %Y") + ' '
      out += '(Week ' + week.to_s + ')'
      return out 
  end

  def show_short_date(year,week)
      out  = Date.commercial(year, week, 1).to_datetime.to_s(:date) + ' - '
      out += Date.commercial(year, week, 5).to_datetime.to_s(:date) + ' '
      out += '(Week ' + week.to_s + ')'
      return out 
  end

  def url_for_next_week(year,week)
    begin
      if (week==52)
        year += 1
        week = 1
      else
        week += 1
      end
      return hoursreports_path(:year => year.to_s, :week => week.to_s, :escape => false)
    rescue Exception => e
      logger.error { "Error [hours_helper.rb/url_for_next_week] #{e.message}" }
    end
  end
  
  def url_for_prev_week(year,week)
    begin
      if (week==1)
        week = 52
        year -= 1
      else
        week -= 1
      end
      return hoursreports_path(:year => year.to_s, :week => week.to_s, :escape => false)
    rescue Exception => e
      logger.error { "Error [hours_helper.rb/url_for_prev_week] #{e.message}" }
    end
  end

  def url_for_week(year,week)
    begin
      return hoursreports_path(:year => year.to_s, :week => week.to_s, :escape => false)
    rescue Exception => e
      logger.error { "Error [hours_helper.rb/url_next_week] #{e.message}" }
    end
  end
  
  def get_jobs(project)
    begin
      return project.jobs.find_all_by_employee_id(session[:user_id])
    rescue Exception => e
      logger.error { "Error [hours_helper.rb/get_jobs] #{e.message}" }
    end
  end
  
  # Calculates the earliest starting date for the employee
  # We select all the projects that have a job assigned to the employee and return the earliest
  def start_date
    begin
      p = (Project.find_by_sql ["SELECT DISTINCT (p.date_start) FROM projects p, jobs j WHERE p.id=j.project_id AND j.employee_id=#{session[:user_id]}"])
      if p.blank? 
        return nil
      else
        return (p.min { |a,b| a[:date_start] <=> b[:date_start] })["date_start"]
      end
    rescue Exception => e
      logger.error { "Error [hours_helper.rb/start_date] #{e.message}" }
    end
  end
  
  # If a float is .0, we return an int, otherwise return the float
  def ftoi(foo)
    begin
      return (foo.to_i == foo)? foo.to_i : foo
    rescue Exception => e
      logger.error { "Error [hours_helper.rb/ftoi] #{e.message}" }
    end
  end  
end
