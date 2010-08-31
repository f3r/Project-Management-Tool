class EmployeesController < ApplicationController
  before_filter :check_for_cancel, :only => [:create, :update]
  
  def index
    begin
        @employees = Employee.all
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/index] #{e.message}" }
    end
  end

  def show
    begin
        @employee = Employee.find(params[:id])
        @jobs     = Job.find_all_by_employee_id(params[:id], :order => "project_id")
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/show] #{e.message}" }
    end
  end

  def new
    begin
        @employee = Employee.new
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/new] #{e.message}" }
    end
  end

  def edit
    begin
        @employee = Employee.find(params[:id])
    rescue Exception => e
        logger.error { "Error [employee_controller.rb/edit] #{e.message}"  }
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
