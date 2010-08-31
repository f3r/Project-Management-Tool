class Category < ActiveRecord::Base

    # Validations
    validates_presence_of :name, :level
    validates_numericality_of :level
    
    # Relationships    
    has_many :employees
end
