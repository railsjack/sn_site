class CompanylovedonesController < ApplicationController
	before_filter :authenticate_user!
	def index
    @lovedones = Lovedone.all
  	@company = Company.find(params[:company_id])
  	@providers = @company.providers.pluck(:lovedone_id)
    @provider = @company.providers.build
  end

  def new
  	@company = Company.find(params[:company_id])
  	@provider = @company.providers.build
  end

  def create
  	lovedone_id = provider_params[:lovedone]
  	@company = Company.find(params[:company_id])
  	@provider = @company.providers.build
  	unless @company.providers.where(lovedone_id: lovedone_id).count==0
  		flash.notice = 'Already assigned.'
  		redirect_to company_companylovedones_path(@company) and return
  	end

  	@provider.lovedone_id = lovedone_id
  	
  	if @provider.save
  		#flash.notice = 'Successfully saved!'
  	else
  		flash.notice = 'There was an error while saving data.'
  	end
  	redirect_to company_companylovedones_path(@company)
  end

  def edit
  end

  def destroy
  	@provider = Provider.find_by(company_id: params[:company_id], lovedone_id: params[:id])
  	@provider.destroy
  	#flash.notice = 'The selected lovedone has been successfully removed.'
  	redirect_to company_companylovedones_path(@provider.company)
  end


  private
  def provider_params
  	params.require(:provider).permit(:lovedone)
  end
end
