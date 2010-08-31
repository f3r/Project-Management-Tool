class JobsController < ApplicationController
  before_filter :load_project, :only => [:new, :create]
  before_filter :check_for_cancel, :only => [:create, :update]
  
  def new
    begin
      @job = Job.new
      @project   = Project.find(params[:project_id])
      @employees = Employee.find(:all)
    rescue Exception => e
      logger.error { "Error [jobs_controller.rb/new] #{e.message}" }
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @job = @project.jobs.new(params[:job])
    if @job.save
      flash[:notice] = 'Job was successfully created.'
      redirect_to(@job.project)
    else
      flash[:notice] = "Error creating job: #{@job.errors}"
      redirect_to(@job.project)
    end
  end

  def edit
    begin
      @job        = Job.find(params[:id])
      @employees  = Employee.find(:all)
    rescue Exception => e
      logger.error { "Error [jobs_controller.rb/edit] #{e.message}" }
    end
  end

  def update
    begin
      @job = Job.find(params[:id])
      if @job.update_attributes(params[:job])
        flash[:notice] = "Job was successfully updated."
        redirect_to(@job.project)
      else
        render :action => 'edit'
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
        logger.error { "EEEEEEEEEEEEEE --> #{@proj.name}" }
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
