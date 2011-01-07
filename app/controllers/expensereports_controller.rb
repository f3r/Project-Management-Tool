class ExpensereportsController < ApplicationController
  include ApplicationHelper
  before_filter :protect_user

  def index
    if params[:month] && params[:year]
      date = Date.parse("1-#{params[:month]}-#{params[:year]}")
      @start_date = date.beginning_of_month
      @end_date = date.end_of_month
      if params[:employee_id]
        employee = params[:employee_id]
      else
        employee = session[:user_id]
      end
      @expensereports_all = Expensereport.find_all_by_employee_id(employee, :include => :project)
      @employees = Employee.all
      @employee = @employees.detect { |employee_object| employee_object.id == employee.to_i }
      @categories = ExpenseCategory.all
      if params[:category]
        @category = @categories.detect{ |category| category.slug == params[:category]}
      else
        @category = ExpenseCategory.new
      end
      @projects = []
      for expense in @expensereports_all do
        unless @projects.include?(expense.project)
          @projects << expense.project
        end
      end
      unless @category.id.blank?
        @expensereports = Expensereport.find(:all, :include => :job, :conditions => {:employee_id => employee, :expense_date => @start_date..@end_date, :expense_category_id => @category.id})
      else
        @expensereports = Expensereport.find(:all, :include => :job, :conditions => {:employee_id => employee, :expense_date => @start_date..@end_date})
      end
    else
      redirect_to expense_report_by_date_path(:month => Date.today.month,:year => Date.today.year)
    end
  end

  def show
    @expensereport = Expensereport.find(params[:id])
  end

  def new
    # We get all the projects and jobs that belong to an employee
    jobs = Job.find_all_by_employee_id(session[:user_id])
    @projects = Array.new
    jobs.each do |job|
      if !@projects.include?(Project.find(job.project_id))
        @projects << Project.find(job.project_id)
      end 
    end
    @expensereport = Expensereport.new
    @jobs = []
  end

  def edit
    if Expensereport.exists?(params[:id])
      @jobs = Job.find_all_by_employee_id(session[:user_id])
      @projects = Array.new
      @jobs.each do |job|
        if !@projects.include?(Project.find(job.project_id))
          @projects << Project.find(job.project_id)
        end 
      end    
      @expensereport = Expensereport.find(params[:id])
    else
      redirect_to(expensereports_url)
    end
  end

  def create
    @expensereport = Expensereport.new(params[:expensereport])
    @expensereport.employee_id = session[:user_id]

    if @expensereport.save
        month = @expensereport.expense_date.strftime("%m")
        year = @expensereport.expense_date.strftime("%Y")
        flash[:notice] = 'Expense Report was successfully created.'
        redirect_to expensereports_path(:month => month, :year => year)
    else
        jobs = Job.find_all_by_employee_id(session[:user_id])
        @projects = Array.new
        jobs.each do |job|
          if !@projects.include?(Project.find(job.project_id))
            @projects << Project.find(job.project_id)
          end 
        end
        @jobs = Job.find_all_by_project_id(params[:expensereport][:project_id])
        render :action => "new"
    end
  end

  def update
    @expensereport = Expensereport.find(params[:id])
    if @expensereport.update_attributes(params[:expensereport])
        month = @expensereport.expense_date.strftime("%m")
        year = @expensereport.expense_date.strftime("%Y")
        flash[:notice] = 'Expense Report was successfully updated.'
        redirect_to expensereports_path(:month => month, :year => year)
    else
        render :action => "edit"
    end
  end

  def destroy
    @expensereport = Expensereport.find(params[:id])
    @expensereport.destroy
    redirect_to(expensereports_url)
  end

end
