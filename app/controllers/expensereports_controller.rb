class ExpensereportsController < ApplicationController
    include ApplicationHelper
    before_filter :protect_user
    filter_resource_access

  def index

    # CHECK USER
    @employees = Employee.all
    if params[:employee_id]
      employee = params[:employee_id]
      @employee = @employees.detect { |e| e.id == employee.to_i }
    end
    
    @projects = user_projects(current_user)
    
    # DATE CHECK
    
    if params[:month] && params[:year]
      @month = params[:month]
      @year = params[:year]
    else
      @month = Date.today.month
      @year = Date.today.year
    end

    if permitted_to? :manage, :projects or @employee == current_user

      if params[:month] && params[:year]
      
        date = Date.parse("1-#{@month}-#{@year}")

        @start_date = date.beginning_of_month
        @end_date = date.end_of_month

        if @employee
          @expensereports_all = Expensereport.find_all_by_employee_id(employee, :include => :project, :order => "expensereports.expense_date ASC")
        else
          @expensereports_all = Expensereport.find(:all, :include => :project, :order => "expensereports.expense_date ASC")
        end

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

        # EXPENSES LIST

        conds = []
        conds << {:expense_date => @start_date..@end_date}

        if @category.id.present?
          conds << { :expense_category_id => @category.id}
        end

        if params[:employee_id]
          conds << { :employee_id => params[:employee_id] }
        end

        conditions = Expensereport.merge_conditions(*conds)
        @expensereports = Expensereport.find(:all, :include => :job, :conditions => conditions, :order => "expensereports.expense_date ASC")


      else
        if @employee
          redirect_to expense_report_by_employee_path(:month => @month,:year => @year, :employee_id => @employee.id)
        else
          redirect_to expense_report_by_date_path(:month => @month,:year => @year)
        end
      end

    else
      # flash[:error] = "Sorry, you are not allowed to access that page."
      redirect_to expense_report_by_employee_path(:month => @month,:year => @year, :employee_id => current_user.id)
    end




  end

  def show
    @expensereport = Expensereport.find(params[:id])
  end

  def new
    @expensereport = Expensereport.new
    @projects = user_projects(current_user)
    @jobs = []
  end

  def edit
    if Expensereport.exists?(params[:id])
      @jobs = Job.find_all_by_employee_id(session[:user_id])
      @projects = user_projects(current_user)
      @expensereport = Expensereport.find(params[:id])
    else
      redirect_to(expensereports_url)
    end
  end

  def create
    @expensereport = Expensereport.new(params[:expensereport])
    @expensereport.employee_id = Job.find(params[:expensereport][:job_id]).employee_id if (@expensereport.employee_id.blank? && !params[:expensereport][:job_id].blank?)
    @expensereport.expense_date = Time.now.to_date if @expensereport.expense_date.blank?

    if @expensereport.save
        month = @expensereport.expense_date.strftime("%m")
        year = @expensereport.expense_date.strftime("%Y")
        flash[:notice] = 'Expense Report was successfully created.'
        redirect_to expense_report_by_date_path(:month => month, :year => year)
    else
        jobs = Job.find_all_by_employee_id(session[:user_id])
        @projects = user_projects(current_user)
        @jobs = Job.find_all_by_project_id(params[:expensereport][:project_id])
        render :action => "new"
    end
  end

  def update
    @expensereport = Expensereport.find(params[:id])
    # if @expensereport.employee_id.blank? && params[:expensereport][:employee_id].blank?
    #   params[:expensereport][:employee_id] == current_user.id
    # end
    if @expensereport.update_attributes(params[:expensereport])
        month = @expensereport.expense_date.strftime("%m")
        year = @expensereport.expense_date.strftime("%Y")
        flash[:notice] = 'Expense Report was successfully updated.'
        redirect_to expense_report_by_date_path(:month => month, :year => year)
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
