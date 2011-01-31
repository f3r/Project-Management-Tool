class IntranetController < ApplicationController

  include ApplicationHelper
  before_filter :protect_user
  filter_resource_access

  def index
    if permitted_to? :view, :projects
      redirect_to projects_path
    elsif current_user.has_role?("secretary")
      redirect_to clients_path
    end
  end
end