class LeadsController < ApplicationController
  before_filter :authenticate_user!    
  before_action :set_lead, only: [:show, :edit, :update, :destroy]

  # GET /leads
  # GET /leads.json
  def index
    if current_user.admin?
        @leads = Lead.all
    else    
        @leads = Lead.where(profile: current_user.profile)    
    end    
    #only show leads for currrent user  
    #@profile = Profile.find(params[:profile_id])  
    @profile = Profile.find(current_user.profile)
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
      @profile = Profile.find(current_user.profile)
  end

  # GET /leads/new
  def new
    @profile = Profile.find(params[:profile_id])  
    @lead = @profile.leads.build #Lead.new
  end

  # GET /leads/1/edit
  def edit
      @profile = Profile.find(params[:profile_id])
      @lead = @profile.leads.find(params[:id])
  end

  # POST /leads
  # POST /leads.json
  def create
    @profile = Profile.find(params[:profile_id])  
    #@lead = Lead.new(lead_params)
    @lead = @profile.leads.create(lead_params)  
      
    respond_to do |format|
      if @lead.save
        format.html { redirect_to profile_leads_url(@profile), notice: 'Lead has been successfully created.' }
        format.json { render :show, status: :created, location: @lead }
      else
        format.html { render :new }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    @profile = Profile.find(params[:profile_id]) 
    @lead = @profile.leads.find(params[:id])  
      
    respond_to do |format|
      if @lead.update(lead_params)
        #format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
        format.html { redirect_to profile_leads_url(@profile), notice: 'Lead has been successfully updated.' }
          
        format.json { render :show, status: :ok, location: @lead }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @profile = Profile.find(params[:profile_id])  
    @lead = @profile.leads.find(params[:id])
      
    @lead.destroy
    respond_to do |format|
      #format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
        format.html { redirect_to profile_leads_url(@profile), notice: 'Lead has been successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.require(:lead).permit(:name, :email, :phone_number, :profile_id)
    end
end
