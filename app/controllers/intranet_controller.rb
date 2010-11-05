class IntranetController < ApplicationController

  include ApplicationHelper
  before_filter :protect_user

  def index
  end
end
