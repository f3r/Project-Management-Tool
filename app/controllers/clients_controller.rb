class ClientsController < ApplicationController
  include ApplicationHelper
  before_filter :protect_user
  filter_resource_access
  
  def index
    @clients = Client.with_permissions_to(:show).paginate :page => params[:page], :order => 'name'
  end
  
  def show
    @client = Client.find(params[:id])
    conds = []
    conds << ["projects.client_id = ?", @client.id]
    unless permitted_to? :manage, :projects
      conds << ["jobs.employee_id = ? OR projects.manager_id = ?", current_user.id, current_user.id]
    end
    conditions = Project.merge_conditions(*conds)
    @projects = Project.find(:all, :conditions => conditions, :include => [:jobs], :order => 'projects.status_id ASC, projects.name')
  end
  
  def new
    @client = Client.new
  end
  
  def edit
    @client = Client.find(params[:id])
  end
  
  def create
    @client = Client.new(params[:client])
    
    if @client.save
      flash[:notice] = 'Client was successfully created.'
      redirect_to(@client)
    else
      render :action => "new"
    end
  end
  
  def update
    @client = Client.find(params[:id])
    
    if @client.update_attributes(params[:client])
      flash[:notice] = 'Client was successfully updated.'
      redirect_to(@client)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @client = Client.find(params[:id])
    @client.destroy 
    redirect_to(clients_url)
  end

end