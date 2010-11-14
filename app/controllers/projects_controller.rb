class ProjectsController < ApplicationController

  include ApplicationHelper
  before_filter :protect_user
  
  def get_projects
      @status = Status.all
      if params[:id] == 0 
          @projects = Project.all
      else
          @projects = Project.find_all_by_status_id(params[:id])
      end
      @status_name = Status.find(params[:id]).name
      render :index, :layout => false do |page|
          page.replace_html 'project_list', :partial => 'list_projects', :projects => @projects, :status_name => @status_name
      end
  end
  
  def index
    @status = Status.all 
    @projects = Project.all(:order => "status_id ASC, name")
    @status_name = "All"
  end

  def show
    @project = Project.find(params[:id])
    @jobs    = @project.jobs.find(:all)
  end

  def new
    begin
        @project  = Project.new
        @partners = Employee.get_partners
        @managers = Employee.get_managers
        @clients  = Client.find(:all)
        @statuses = Status.find(:all)
    rescue Exception => e
        logger.error { "Error [projects_controller.rb/new] #{e.message}" }
    end
  end

  def edit
    @project = Project.find(params[:id])
    @partners = Employee.get_partners
    @managers = Employee.get_managers
    @clients  = Client.find(:all)
    @statuses = Status.find(:all)
  end

  def create
     begin
         @project = Project.create_project(params[:project])
         if @project.save
             flash[:notice] = 'Project was successfully created.'
             redirect_to(projects_url)
         else
             @partners = Employee.get_partners
             @managers = Employee.get_managers
             @clients  = Client.find(:all)
             @statuses = Status.find(:all)
             render :action => "new"
         end
     rescue Exception => e
       logger.error { "Error [projects_controller.rb/create] #{e.message}" }
       render :action => "new"
     end
   end

  def update
    @project = Project.find(params[:id])

      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        redirect_to(@project)
      else
        render :action => "edit"
      end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to(projects_url)
  end
end
