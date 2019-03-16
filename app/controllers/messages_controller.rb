class MessagesController < ApplicationController
  before_filter :authenticate_user!
  def index
  	@company = current_user.company
  	@employee = Employee.first
  	@employees = current_user.company.employees.order('last_name ASC')
  end

  def new
  end

  def edit
  end

  def show
  end

end
