ActionController::Routing::Routes.draw do |map|

  # ADD , :shallow => true abajo
  map.resources :projects, :has_many => :jobs, :shallow => true
  map.resources :clients
  map.resources :categories, :has_many => :employees
  map.resources :employees
  map.resources :expensereports
  map.connect 'hoursreports/:year/:week',
             :controller => 'hours',
             :action     => 'index'
 
  map.connect 'js/:emp_id/:week_no/:year',
             :controller => 'Js',
             :action     => 'index'

  map.root :controller => "site", :action => 'index' 

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
