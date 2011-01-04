class Status < ActiveRecord::Base
  has_many :jobs
  
  def self.list
     Rails.cache.fetch('status_list', :expires_in => 86400) { all.reverse }
  end
end
