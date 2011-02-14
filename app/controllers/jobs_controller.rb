class JobsController < ApplicationController
  include ApplicationHelper
  before_filter :protect_user

  before_filter :load_project, :only => [:new, :create]
  
  filter_resource_access
  
  def new
    begin
      @job = Job.new
      @project   = Project.find(params[:project_id])
      @employees = Employee.find(:all)
      @job.employee = current_user if @job.employee.blank?
      @statuses  = Status.find(:all)
    rescue Exception => e
      logger.error { "Error [jobs_controller.rb/new] #{e.message}" }
    end
  end

  def create
    if params[:commit] == "Cancel"
      redirect_to(@job.project)
    else  
      @project = Project.find(params[:project_id])
      @job = @project.jobs.new(params[:job])
      if @job.save
        flash[:notice] = 'Job was successfully created.'
        redirect_to(@job.project)
      else
        flash[:error] = "Error creating job"
        render :action => "new"
      end
    end
  end

  def edit
    begin
      @job       = Job.find(params[:id])
      @project   = Project.find(params[:project_id])
      @employees = Employee.find(:all)
      @statuses  = Status.find(:all)
    rescue Exception => e
      logger.error { "Error [jobs_controller.rb/edit] #{e.message}" }
    end
  end

  def update
    begin
      if params[:commit] == "Cancel"
        redirect_to(@job.project)
      else  
        @job = Job.find(params[:id])
        if @job.update_attributes(params[:job])
          flash[:notice] = "Job was successfully updated."
          redirect_to(@job.project)
        else
          render :action => 'edit'
        end
      end
    rescue Exception => e
      logger.error { "Error [jobs_controller.rb/update] #{e.message}" }
    end
  end

  def destroy
    begin
        @job = Job.find(params[:id])
        @proj = @job.project
        @job.destroy
        flash[:notice] = 'Job was successfully deleted.'
        redirect_to(@proj)
    rescue Exception => e
        logger.error { "Error [jobs_controller.rb/destroy] #{e.message}" }
    end
  end

  def load_project
    begin
        @project = Project.find(params[:project_id]) 
    rescue Exception => e
        logger.error { "Error [jobs_controller.rb/load_project] #{e.message}" }
    end
  end

end
