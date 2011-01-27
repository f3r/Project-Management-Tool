class ProjectsController < ApplicationController

  include ApplicationHelper
  before_filter :protect_user

  filter_resource_access
  filter_access_to [:index, :get_jobs], :attribute_check => false  
  
  def index
    @status = Status.all 

    if params[:id].to_i == 0 or params[:id] == blank?
      @status_name = "All"
      status = ""
    else
      @status_name = Status.find(params[:id]).name
      status = params[:id]
    end

    if permitted_to? :manage, :projects
      conditions = ["projects.status_id LIKE ?", "%#{status}%"]
    else
      conditions = ["(jobs.employee_id = ? OR projects.manager_id = ?) AND projects.status_id LIKE ?", current_user.id, current_user.id, "%#{status}%"]
    end
    @projects = Project.paginate( :conditions => conditions,
                                  :include => [:client, :status, :partner, :manager, :jobs, :expensereports],
                                  :page => params[:page],
                                  :order => 'projects.status_id ASC, projects.name')

    if params[:ajax]=="true"
      render :index, :layout => "project_list" do |page|
        page.replace_html 'project_list', :partial => 'list_projects'
      end
    end


  end

  def show
    @project = Project.find(params[:id])
    @jobs    = @project.jobs.all
  end

  def new
    begin
        @project  = Project.new
        @project.manager = current_user
        @partners = Employee.get_partners
        @managers = Employee.get_managers
        @clients  = Client.find(:all)
        @statuses = Status.find(:all)
    rescue Exception => e
        logger.error { "Error [projects_controller.rb/new] #{e.message}" }
    end
  end

  def edit
    begin
      @project = Project.find(params[:id])
      @partners = Employee.get_partners
      @managers = Employee.get_managers
      @clients  = Client.find(:all)
      @statuses = Status.find(:all)
    rescue Exception => e
        logger.error { "Error [projects_controller.rb/edit] #{e.message}" }      
    end
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
    begin
      @project = Project.find(params[:id])
      if @project.has_pending_jobs? and params[:project][:status_id].to_i == 3
        flash[:error] = 'To close a Project you must first finish all its jobs'
        render :action => "edit"
      else
        if @project.update_attributes(params[:project])
          flash[:notice] = 'Project was successfully updated.'
          redirect_to(@project)
        else
          flash[:notice] = 'There was some problem saving your changes.'
          render :action => "edit"
        end
      end

    rescue Exception => e
      logger.error { "Error [projects_controller.rb/update] #{e.message}" }
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to(projects_url)
  end

  def get_jobs
    @project = Project.find(params[:id])
    if permitted_to? :manage, @project
      @jobs = @project.jobs
    else
      @jobs = @project.jobs.find(:all, :conditions => { :employee_id => current_user.id } )
    end
    respond_to do |format|
      format.json { render :json => { :jobs => @jobs, :project => @project }.to_json }
    end
  end

  private
  

end