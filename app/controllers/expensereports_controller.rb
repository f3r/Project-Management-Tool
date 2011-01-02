class ExpensereportsController < ApplicationController
  include ApplicationHelper
  before_filter :protect_user

  def index
    if params[:month] && params[:year]

      @expensereports_all = Expensereport.find_all_by_employee_id(session[:user_id], :include => :project)
      # @projects = Project.all
      # @projects = @expensereports_all.map{|expense| expense.project}
      @projects = []
      for expense in @expensereports_all do
        unless @projects.include?(expense.project)
          @projects << expense.project
        end
      end

      date = Date.parse("1-#{params[:month]}-#{params[:year]}")
      @start_date = date.beginning_of_month
      @end_date = date.end_of_month
      @expensereports = Expensereport.find(:all, :include => :job, :conditions => {:employee_id => session[:user_id], :expense_date => @start_date..@end_date})
    else
      redirect_to expense_report_by_date_path(:month => Date.today.month,:year => Date.today.year)
    end
  end

  def show
    @expensereport = Expensereport.find(params[:id])
  end

  def new
    # We get all the projects and jobs that belong to an employee
    @jobs = Job.find_all_by_employee_id(session[:user_id])
    @projects = Array.new
    @jobs.each do |job|
      if !@projects.include?(Project.find(job.project_id))
        @projects << Project.find(job.project_id)
      end 
    end
    @expensereport = Expensereport.new
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
        flash[:notice] = 'Expense Report was successfully created.'
        redirect_to(expensereports_url)
    else
        @jobs = Job.find_all_by_employee_id(session[:user_id])
        @projects = Array.new
        @jobs.each do |job|
          if !@projects.include?(Project.find(job.project_id))
            @projects << Project.find(job.project_id)
          end 
        end      
        render :action => "new"
    end
  end

  def update
    @expensereport = Expensereport.find(params[:id])
    if @expensereport.update_attributes(params[:expensereport])
        flash[:notice] = 'Expense Report was successfully updated.'
        redirect_to(expensereports_url)
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
