class LovedonecompaniesController < ApplicationController
	before_filter :authenticate_user!
  def index
  	@companies = Company.all
  	@lovedone = Lovedone.find(params[:lovedone_id])
  	@providers = @lovedone.providers.pluck(:company_id)
  	@provider = @lovedone.providers.build
  end

  def new
  	@companies = Company.all
  	@lovedone = Lovedone.find(params[:lovedone_id])
  	@provider = @lovedone.providers.build

  end

  def create
  	company_id = provider_params[:company]
  	@lovedone = Lovedone.find(params[:lovedone_id])
  	@provider = @lovedone.providers.build
  	unless @lovedone.providers.where(company_id: company_id).count==0
  		flash.notice = 'Already assigned.'
  		redirect_to lovedone_lovedonecompanies_path(@lovedone) and return
  	end

  	@provider.company_id = company_id
  	
  	if @provider.save
  		#flash.notice = 'Successfully saved!'
  	else
  		flash.notice = 'There was an error while saving data.'
  	end
  	redirect_to lovedone_lovedonecompanies_path(@lovedone)
  end

  def edit
  end

  def destroy
  	@provider = Provider.find_by(company_id: params[:id], lovedone_id: params[:lovedone_id])
  	@provider.destroy
  	#flash.notice = 'The selected lovedone has been successfully removed.'
  	redirect_to lovedone_lovedonecompanies_path(@provider.lovedone)
  end


  private
  def provider_params
  	params.require(:provider).permit(:company)
  end
end
