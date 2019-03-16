class ProvidersController < ApplicationController
  before_filter :authenticate_user!    
  before_action :set_provider, only: [:show, :edit, :update, :destroy]

  def index
    @providers = Provider.all
    @lovedone = Lovedone.find(params[:lovedone_id])  
  end

  def show
      @lovedone = Lovedone.find(params[:lovedone_id])
  end

  def new
    @lovedone = Lovedone.find(params[:lovedone_id])  
    @provider = @lovedone.providers.build
  end

  def edit
      @lovedone = Lovedone.find(params[:lovedone_id])
      @provider = @lovedone.providers.find(params[:id])  
  end

  def create
    @lovedone = Lovedone.find(params[:lovedone_id])  
    @provider = @lovedone.providers.create(provider_params)
      
    respond_to do |format|
      if @provider.save
        format.html { redirect_to edit_lovedone_path(@lovedone), notice: 'Provider has been successfully created.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @lovedone = Lovedone.find(params[:lovedone_id]) 
    @provider = @lovedone.providers.find(params[:id]) 
      
    respond_to do |format|
      if @provider.update(provider_params)
        format.html { redirect_to edit_lovedone_path(@lovedone), notice: 'Provider has been successfully updated.' }
        format.json { render :show, status: :ok, location: @provider }
      else
        format.html { render :edit }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lovedone = Lovedone.find(params[:lovedone_id]) 
    @provider = @lovedone.providers.find(params[:id]) 
      
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to edit_lovedone_path(@lovedone), notice: 'Provider has been successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @provider = Provider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_params
      params.require(:provider).permit(:company_id, :lovedone_id)
    end
end
