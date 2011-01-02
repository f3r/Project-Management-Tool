module ExpensereportsHelper

  def expense_chart(start_time, end_time, user, project)
    expenses_by_day = Expensereport.find( :all, 
                                          :conditions => {:expense_date => start_time.beginning_of_day..Time.zone.now.end_of_day, :project_id => project, :employee_id => user}, 
                                          :group => "date(expense_date)", 
                                          :select => "expense_date, sum(amount) as total_amount")

    (start_time..end_time).map do |date|
      expense = expenses_by_day.detect { |expense| expense.expense_date.to_date == date }
      expense && expense.total_amount.to_f || 0
    end.inspect
  end

end