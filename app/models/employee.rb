class Employee < ActiveRecord::Base
    
    # Validations
    validates_presence_of   :first_name, :last_name, :nif, :email
    validates_format_of     :nif,   :with => /^[A-Za-z0-9]*$/
    validates_format_of     :email, :with => /^[A-Z0-9.+_%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
    validates_uniqueness_of :email, :nif

    # Paperclip
    has_attached_file :photo,
      :styles => {
          :thumb  => "100x100#",
          :small  => "150x150>",
          :medium => "300x300>",
          :large  => "400x400>" },
      :storage => :s3, 
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
      :path => "/:style/:filename",
      :bucket => 'shp-intranet2'
        
    # Relationships
    belongs_to :category
    has_many   :projects
    has_many   :jobs
    
    attr_protected  :id
    attr_accessor   :password_confirmation
    
    def self.create_employee(params)
      begin
          logger.error { "PARAMS TO CREATE EMPLOYEE #{params.to_yaml}" }
          user = Employee.new(params)
          user.password = user.nif
          user.password_confirmation = user.nif
          user.encrypt_password!
          user.save
          return user
      rescue Exception => e
          logger.error { "Error [employee.rb/create_employee] #{e.message}" }
      end        
    end

    def self.password_from_mail(email)
        begin
            user = Employee.find_by_email(email)
            return user.password if user
            return nil           if !user
        rescue Exception => e
            logger.error { "Error [employee.rb/password_from_mail] #{e.message}" }
        end
    end
    
    def encrypt_password!
        begin
            self.password              = Digest::SHA1.hexdigest("#{self.email}|#{self.password}")              if self.password
            self.password_confirmation = Digest::SHA1.hexdigest("#{self.email}|#{self.password_confirmation}") if self.password_confirmation
        rescue Exception => e
            logger.error { "Error [employee.rb/encrypt_password] #{e.message}" }
        end    
    end

    def clear_passwords!
        begin
            self.password = nil
            self.password_confirmation = nil            
        rescue Exception => e
            logger.error { "Error [employee.rb/clear_passwords]: #{e.message}" }
        end
    end

    def log_in_session!(session)
        begin
            session[:user_id]   = self.id
            session[:user_name] = self.first_name
            session[:is_admin?] = (self.category.level == 10000)
            session[:level]     = self.category.level
        rescue Exception => e
            logger.error { "Error [employee.rb/log_in_session] #{e.message}" }
        end
    end

    def update_user!(params, session)
        begin
            self.update_attributes!(params)
            unless params[:password].nil?
              encrypt_password!
              self.save!
            end	
            session[:user_name] = self.name            
        rescue Exception => e
            logger.error { "Error [employee.rb/log_in_session] #{e.message}" }
        end
    end

    def new_reset_uuid!
        begin
            self.reset_uuid = SecureRandom.hex(40)
            self.save!            
        rescue Exception => e
            logger.error { "Error [employee.rb/new_reset_uuid] #{e.message}" }
        end
    end
    
    def clear_reset_uuid!
        begin
            self.reset_uuid = nil
            self.save!
        rescue Exception => e
            logger.error { "Error [employee.rb/new_reset_uuid] #{e.message}" }
        end
    end     
    def self.get_partners
        begin
            return Employee.find(:all, :conditions => ["category_id =?",2]) 
        rescue Exception => e
            logger.error { "Error [employee.rb/get_partners] #{e.message}" }
        end
    end

    def self.get_managers
        begin
            return Employee.find(:all, :conditions => ["category_id >? and category_id<?",2,5])            
        rescue Exception => e
            logger.error { "Error [employee.rb/get_manaters] #{e.message}" }
        end
    end
    
    def full_name
        begin
            return "#{self.first_name} #{self.last_name}"
        rescue Exception => e
            logger.error { "Error [employee.rb/full_name] #{e.message}" }
        end 
    end
    
    def number_of_jobs
        begin
            return self.jobs.count
        rescue Exception => e
            logger.error { "Error [employee.rb/number_of_jobs] #{e.message}" }
        end
    end
end
