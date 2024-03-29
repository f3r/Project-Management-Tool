class SiteController < ApplicationController
  layout 'site'
  include SiteHelper
  include ApplicationHelper
  
  before_filter :protect_user, :except => [:login, :remind, :reset, :index]
  
  # Aqui pondremos una vez se logueen
  def index
    redirect_to login_path
  end
  
  def login
      @title = 'Employee Login'
      begin
          # If user is LOGGED IN already
          if request.get? and session[:user_id]
              redirect_to :controller => 'intranet', :action => 'index'
          end

          # If user submit data, and data is correct
          if request.post? and params[:user] and !params[:user].empty?
              email          = params[:user][:email]
              encrypted_pwd  = Digest::SHA1.hexdigest("#{email.downcase}|#{params[:user][:password]}")
	      employee_pwd = Employee.get_password(email)

	      if encrypted_pwd == employee_pwd
                  user = Employee.find_by_email(email)
                  user.log_in_session!(session)
                  flash[:notice] = "#{'Welcome back '} #{user.first_name}"
                  redirect_to projects_path
              else
                  flash[:error] = 'Sorry, your email & password combination does not match'
                  return
              end
          end
      rescue Exception => e
        logger.error { "Error [site_controller.rb/login] #{e.message}" }
      end    
  end
  
  def logout
      begin
          session[:user_id]   = nil
          session[:user_name] = nil
          session[:is_admin?] = nil
          session[:level]     = nil
          redirect_to :controller => 'site', :action => 'index'
      rescue Exception => e
        logger.error { "Error [site_controller.rb/logout] #{e.message}" }
      end    
  end
  
  def remind
    begin
        @title = 'Forgot password'

        if request.post? and params[:site][:email]
            user = Employee.find_by_sql ["SELECT * FROM employees WHERE lower(email) = lower(?)", params[:site][:email]]
            user = user.first
            if user
                user.new_reset_uuid!
                reset_link = "#{request.protocol}#{request.host}:#{request.port}/reset_password/#{user.reset_uuid}"
                UserMailer.deliver_reset_password(user,reset_link)
                flash[:notice] = 'A password reset link has been sent to your mail account'
                # logger.error { reset_link }
                redirect_to :controller => 'site', :action => 'login'
            else
                flash[:error] = 'Sorry, your email has not been found. Please contact the administrator'
            end
        end
    rescue Exception => e
        logger.error { "Error [site_controller.rb/remind] #{e.message}" }
    end
  end
  
  def reset
    begin
        @title = 'Password Reset'
        if request.get? and params[:reset_code]
            @user = Employee.find_by_reset_uuid(params[:reset_code])
            if !@user
                flash[:error] = 'Sorry, the reset code has expired or is invalid'
                redirect_to :controller => 'site', :action => 'login'
            end
        end
        
        if request.post? and params[:user_id]
            @user    = Employee.find(params[:user_id])
            pwd      = params[:password]
            pwd_conf = params[:password_confirmation]
            if pwd and pwd_conf and (pwd == pwd_conf) and !pwd.empty?
                @user.password = pwd
                @user.password_confirmation = pwd_conf
                @user.encrypt_password!
                @user.clear_reset_uuid!
                @user.save!
                flash[:notice] = "Your password has successfully been changed!"
                redirect_to :controller => 'site', :action => 'login'
            else
                flash[:error] = 'Please fill both fields' if !pwd or !pwd_conf or pwd.empty?
                flash[:error] = 'Your passwords do not match'  if pwd and pwd_conf and (pwd != pwd_conf)
            end
        end
    rescue Exception => e
        logger.error { "Error [site_controller.rb/reset] #{e.message}" }
    end        
  end    
end
