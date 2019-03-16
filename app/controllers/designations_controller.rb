class DesignationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :setup_params
  def index
  	@all_designations = @company.designations
    @designation = Designation.new
  end

  def new
    @designation = Designation.new
  end

  def edit
    @designation = Designation.find(params[:id])
  end

  def create
		@company.designations.create(designations_params) unless @company.nil?
  	redirect_to company_designations_path
  end

  def update
    @designation = Designation.find(params[:id])
    @designation.update(designations_params)
    redirect_to company_designations_path
  end

  def destroy
  	Designation.destroy(params[:id])
  	redirect_to :back
  end


  private
  def check_login
    redirect_to root_path if current_user.nil?
  end
  def setup_params
    @company_id = params[:company_id]
    @company = Company.find(@company_id)
    @current_company = @company
  end

  def designations_params
    params.require(:designation).permit(:name, :color)
  end
end
