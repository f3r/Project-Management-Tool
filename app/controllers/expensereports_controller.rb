class ExpensereportsController < ApplicationController

  def index
    @expensereports = Expensereport.all
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
    @jobs = Job.find_all_by_employee_id(session[:user_id])
    @projects = Array.new
    @jobs.each do |job|
      if !@projects.include?(Project.find(job.project_id))
        @projects << Project.find(job.project_id)
      end 
    end    
    @expensereport = Expensereport.find(params[:id])
  end

  def create
    @expensereport = Expensereport.new(params[:expensereport])
    @expensereport.employee_id = session[:user_id]
    if @expensereport.save
        flash[:notice] = 'Expensereport was successfully created.'
        redirect_to(expensereports_url)
    else
        render :action => "new"
    end
  end

  def update
    @expensereport = Expensereport.find(params[:id])
    if @expensereport.update_attributes(params[:expensereport])
        flash[:notice] = 'Expensereport was successfully updated.'
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
