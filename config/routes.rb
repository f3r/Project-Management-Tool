ActionController::Routing::Routes.draw do |map|

  # ADD , :shallow => true abajo
  map.resources :projects, :has_many => :jobs, :shallow => true
  map.resources :clients
  map.resources :categories, :has_many => :employees
  map.resources :employees
  map.resources :expensereports

  map.hours '/hoursreports', :controller => 'hours', :action => 'index'
  
  map.connect 'hoursreports/:year/:week/saveHours',
             :controller => 'hours',
             :action     => 'saveHours',
             :conditions => { :method => :post }
 

  map.hoursreports 'hoursreports/:year/:week',
             :controller => 'hours',
             :action     => 'index'

  map.root :controller => "site", :action => 'index' 

  map.forgot_password '/forgot_password', :controller =>'site', :action => 'remind'
  map.login '/login', :controller =>'site', :action => 'login'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
