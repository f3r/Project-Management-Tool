class EmployeesController < ApplicationController
  include ApplicationHelper
  before_filter :protect_user
  
  filter_resource_access

  def index
    begin
        @employees = Employee.paginate :page => params[:page], :order => 'last_name'
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/index] #{e.message}" }
    end
  end

  def show
    begin
        @employee = Employee.find(params[:id])
        @jobs = Job.find_all_by_employee_id(params[:id], :order => "project_id", :include => { :projects, :clients })
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/show] #{e.message}" }
    end
  end

  def new
    begin
        @employee = Employee.new
        @clients = Client.all
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/new] #{e.message}" }
    end
  end

  def edit
    begin
        @employee = Employee.find(params[:id])
        @clients = Client.all
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/edit] #{e.message}"  }
    end
  end
  
  def change_picture
    begin
        @employee = Employee.find(params[:id])
        if params[:modal] == "true"
          render :layout => false
        end
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/change_picture] #{e.message}" }
    end
  end

  def change_password
    begin
      @employee = Employee.find(params[:id])

      if request.put? && params[:employee][:password] && params[:employee][:password_confirmation]
          pwd      = params[:employee][:password]
          pwd_conf = params[:employee][:password_confirmation]
          if pwd and pwd_conf and (pwd == pwd_conf) and !pwd.empty?
              @employee.password = pwd
              @employee.password_confirmation = pwd_conf
              @employee.encrypt_password!
              @employee.save!
              flash[:notice] = "Your password has successfully been changed!"
              redirect_to employee_path(@employee)
          else
              flash[:error] = 'Please fill both fields' if !pwd or !pwd_conf or pwd.empty?
              flash[:error] = 'Your passwords do not match'  if pwd and pwd_conf and (pwd != pwd_conf)
              redirect_to change_password_path(@employee)
          end
      
      else

        @employee.password = nil
        if params[:modal] == "true"
          render :layout => false
        end

      end

    rescue Exception => e
        logger.error { "Error [employee_controller.rb/change_password] #{e.message}" }
    end
  end

  def create
    begin

        @employee = Employee.create_employee(params[:employee])
        if @employee.save
            flash[:notice] = 'Employee was successfully created.'
            redirect_to(@employee)
        else
            render :action => "new" 
        end

    rescue Exception => e
        logger.error { "Error [employee_controller.rb/create] #{e.message}"  }
    end
  end

  def update
    begin
      
      @employee = Employee.find(params[:id])
      
      if @employee.update_attributes(params[:employee])
          flash[:notice] = 'Employee was successfully updated.'
          redirect_to(@employee)
      else
            render :action => "edit"
      end

    rescue Exception => e
        logger.error { "Error [employee_controller.rb/update] #{e.message}"  }
    end
  end


  def destroy
    begin
        @employee = Employee.find(params[:id])
        @employee.destroy
        redirect_to(employees_url)        
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/destroy] #{e.message}"  }
    end
  end

end
