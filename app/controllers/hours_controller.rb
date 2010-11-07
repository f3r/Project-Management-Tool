class HoursController < ApplicationController

  include ApplicationHelper
  before_filter :protect_user
  
  def index
    # We check if parameters are passed
    if params[:year].blank? || params[:week].blank?
      @year = (params[:year].blank?) ? Time.now.year.to_i : params[:year].to_i
      @week = (params[:week].blank?) ? Time.now.strftime("%W") : params[:week].to_i
      redirect_to url_for(:action => 'index', :year => @year.to_s, :week => @week.to_s, :escape => false)
      return
    end
    
    @year = params[:year].to_i
    @week = params[:week].to_i
    
  end
end
