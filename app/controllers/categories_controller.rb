class CategoriesController < ApplicationController
  include ApplicationHelper
  before_filter :protect_user
  filter_resource_access

  def index
      begin
          @categories = Category.paginate :page => params[:page], :order => 'level DESC'
      rescue Exception => e
          logger.error { "Error [categories_controller.rb/index] #{e.message}" }
      end
  end

  def show
    begin
        @category = Category.find(params[:id]) 
    rescue Exception => e
        logger.error { "Error [categories_controller.rb/show] #{e.message}" }
    end
  end

  def new
    begin
        @category = Category.new 
    rescue Exception => e
        logger.error { "Error [categories_controller.rb/new] #{e.message}" }
    end
  end

  def edit
      begin
          @category = Category.find(params[:id]) 
      rescue Exception => e
          logger.error { "Error [categories_controller.rb/edit] #{e.message}" }
      end
  end

  def create
    begin
        @category = Category.new(params[:category])

        if @category.save
            flash[:notice] = 'Category was successfully created.'
            redirect_to categories_path
        else
            render :action => "new"
        end        
    rescue Exception => e
        logger.error { "Error [categories_controller.rb/create] #{e.message}" }
    end
  end

  def update
    begin
        @category = Category.find(params[:id])

        if @category.update_attributes(params[:category])
            flash[:notice] = 'Category was successfully updated.'
            redirect_to categories_path
        else
            render :action => "edit"
        end        
    rescue Exception => e
        logger.error { "Error [categories_controller.rb/update] #{e.message}" }
    end
  end

  def destroy
    begin    
        @category = Category.find(params[:id])
        @category.destroy

        redirect_to categories_path
    rescue Exception => e
        logger.error { "Error [categories_controller.rb/destroy] #{e.message}" }
    end
  end

end
