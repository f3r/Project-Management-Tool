module ExpensereportsHelper

  def expense_chart(start_time)
    expenses_by_day = Expensereport.find( :all, 
                                          :conditions => {:expenseDate => start_time.beginning_of_day..Time.zone.now.end_of_day}, 
                                          :group => "date(expenseDate)", 
                                          :select => "expenseDate, sum(amount) as total_amount"
                                          )
    (start_time.to_date..Date.today).map do |date|
      expense = expenses_by_day.detect { |expense| expense.expenseDate.to_date == date }
      expense && expense.total_amount.to_f || 0
    end.inspect
  end

end