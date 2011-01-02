module ExpensereportsHelper

  def expense_chart(start_time, end_time, user, project)

    expenses_by_day = Expensereport.find_by_sql(["
    SELECT expenseDate, sum(amount) as total_amount 
    FROM `expensereports` 
    INNER JOIN `projects` ON `projects`.id = `expensereports`.project_id 
    INNER JOIN `jobs` ON jobs.project_id = projects.id 
    WHERE (`expensereports`.`project_id` = ? AND `expensereports`.`expenseDate` 
    BETWEEN ? AND ? AND `expensereports`.`employee_id` = ?) 
    GROUP BY date(expenseDate)", project,start_time,end_time,user
    ])

    (start_time..end_time).map do |date|
      expense = expenses_by_day.detect { |expense| expense.expenseDate.to_date == date }
      expense && expense.total_amount.to_f || 0
    end.inspect
  end

end