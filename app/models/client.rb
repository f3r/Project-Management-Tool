class Client < ActiveRecord::Base
  has_many :projects, :dependent => :destroy
  validates_presence_of   :name, :cif, :email
  validates_format_of     :email, :with => /^[A-Z0-9.+_%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
  validates_uniqueness_of :email, :cif
end
