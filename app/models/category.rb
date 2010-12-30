class Category < ActiveRecord::Base

    # Validations
    validates_presence_of :name, :level
    validates_numericality_of :level
    
    # Relationships    
    has_many :employees

    def self.per_page
      DEFAULT_PER_PAGE
    end

end