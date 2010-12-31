module ExpensereportsHelper

  def expense_chart(start_time, end_time, user, project)
    expenses_by_day = Expensereport.find( :all, 
                                          :conditions => {:expenseDate => start_time.beginning_of_day..end_time.end_of_day, :employee_id => user, :project_id => project}, 
                                          :group => "date(\"expenseDate\")", 
                                          :joins => {:project, :jobs}, 
                                          :select => "expenseDate, sum(amount) as total_amount"
                                          )
    (start_time..end_time).map do |date|
      expense = expenses_by_day.detect { |expense| expense.expenseDate.to_date == date }
      expense && expense.total_amount.to_f || 0
    end.inspect
  end

end