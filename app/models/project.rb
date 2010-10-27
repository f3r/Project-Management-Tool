class Project < ActiveRecord::Base
    # Validations
    validates_presence_of :name, :description, :status, :partner_id, :manager_id, :client_id

    # Relationships
    belongs_to  :partner, :class_name => 'Employee', :foreign_key => 'partner_id'
    belongs_to  :manager, :class_name => 'Employee', :foreign_key => 'manager_id'
    belongs_to  :client
    belongs_to  :status
    has_many    :jobs, :dependent => :destroy
    has_many   :expensereports
    
    def self.create_project(params)
      begin
          project = Project.new(params)
          project.status = Status.find(1)
          project.save
          return project
      rescue Exception => e
          logger.error { "Error [project.rb/create_project] #{e.message}" }
      end        
    end
    
    def number_of_jobs
      begin
          self.jobs.count
      rescue Exception => e
        logger.error { "Error [project.rb/number_of_jobs] #{e.message}" }
      end
    end
  
end
