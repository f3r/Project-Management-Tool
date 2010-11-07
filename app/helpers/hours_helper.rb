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
end
