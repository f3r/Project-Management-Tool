# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  require 'uuidtools'
  
  before_filter :instantiate_controller_and_action_names
  before_filter :set_locale

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  private 

  def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
  end
  
  def set_locale
    I18n.locale = "en"
  end

end
