# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  require 'uuidtools'
  
  before_filter :instantiate_controller_and_action_names

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  private 
  def check_for_cancel
      if params[:commit] == "Cancel"
          redirect_to :action => "show"
      end
  end

  def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
  end
  
end
