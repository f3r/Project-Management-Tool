module ExpensereportsHelper
  def expense_chart(start_time, end_time, employee, project, category)

    conds = []
    conds << {:expense_date => start_time.beginning_of_day..Time.zone.now.end_of_day, :project_id => project.id}

    if category.id.present?
      conds << {:expense_category_id => category.id}
    end

    unless employee.blank?
      conds << {:employee_id => employee.id}
    end

    conditions = Expensereport.merge_conditions(*conds)

    expenses_by_day = Expensereport.find( :all, 
                                          :conditions => conditions, 
                                          :group => "date(expense_date)", 
                                          :select => "expense_date, sum(amount) as total_amount")
    (start_time..end_time).map do |date|
      expense = expenses_by_day.detect { |expense| expense.expense_date.to_date == date }
      expense && expense.total_amount.to_f || 0
    end.inspect

  end
end