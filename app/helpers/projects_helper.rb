module ProjectsHelper
  def date_to_week_number(date)
    return date.strftime("%W")
  end
end
