class SiteController < ApplicationController
  layout 'site'
  include SiteHelper
  include ApplicationHelper
  
  before_filter :protect_user, :except => [:login, :remind, :reset, :index]
  
  # Aqui pondremos una vez se logueen
  def index
    redirect_to :action => 'login'
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
              encrypted_pwd  = Digest::SHA1.hexdigest("#{email}|#{params[:user][:password]}")
              if encrypted_pwd == Employee.password_from_mail(email)
                  user = Employee.find_by_email(email)
                  user.log_in_session!(session)
                  flash[:notice] = "#{'Welcome back '} #{user.first_name}"
                  redirect_to :controller => 'intranet', :action => 'index'
              else
                  flash[:notice] = 'Sorry, your email&password combination does not match'
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
        @title = 'Forgotten your password?'

        if request.post? and params[:site][:email]
            user = Employee.find_by_email(params[:site][:email])
            if user
                user.new_reset_uuid!
                # TODO Configure EMAIL  
                # ExcancelMailer.deliver_password_reset(user, request.host, request.port, protocol)
                flash[:notice] = 'A password reset link has been sent to your mail account'
                logger.error { "#{request.protocol}#{request.host}:#{request.port}/site/reset/#{user.reset_uuid}" }
                redirect_to :controller => 'site', :action => 'login'
            else
                flash[:notice] = 'Sorry, your email has not been found. Please contact the administrator'
            end
        end
    rescue Exception => e
        logger.error { "Error [site_controller.rb/remind] #{e.message}" }
    end
  end
  
  def reset
    begin
        @title = 'Password Reset'
        if request.get? and params[:id]
            @user = Employee.find_by_reset_uuid(params[:id])
            if !@user
                flash[:notice] = 'Sorry, the reset code has expired or is invalid'
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
                flash[:notice] = "Your password has successfully been changed to #{pwd}!"
                redirect_to :controller => 'site', :action => 'login'
            else
                flash[:notice] = 'Please insert both passwords' if !pwd or !pwd_conf or pwd.empty?
                flash[:notice] = 'Your passwords do not match'  if pwd and pwd_conf and (pwd != pwd_conf)
            end
        end
    rescue Exception => e
        logger.error { "Error [site_controller.rb/reset] #{e.message}" }
    end        
  end    
end
