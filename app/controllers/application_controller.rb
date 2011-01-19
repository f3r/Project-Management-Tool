# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  require 'uuidtools'
  
  before_filter :instantiate_controller_and_action_names
  before_filter :set_locale
  # before_filter :set_current_user

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  public
  
  def current_user
    current_user = Employee.find(session[:user_id])
  end

  protected

  def permission_denied
    flash[:error] = "Sorry, you are not allowed to access that page."
    redirect_to root_url
  end

  private 

  def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
  end
  
  def set_locale
    I18n.locale = "en"
  end

end