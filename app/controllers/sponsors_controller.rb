class SponsorsController < ApplicationController
  before_filter :authenticate_user!    
  before_action :set_sponsor, only: [:show, :edit, :update, :destroy]

  # GET /sponsors
  # GET /sponsors.json
  def index
    @sponsors = Sponsor.all
  end

  # GET /sponsors/1
  # GET /sponsors/1.json
  def show
  end

  # GET /sponsors/new
  def new
    @sponsor = Sponsor.new
  end

  # GET /sponsors/1/edit
  def edit
  end

  # POST /sponsors
  # POST /sponsors.json
  def create
    if sponsor_params[:start_date].present? or sponsor_params[:end_date].present?
      start_date = sponsor_params[:end_date]
      end_date = sponsor_params[:end_date]
      sponsor_params[:start_date] = Time.strptime(start_date, '%m/%d/%Y').strftime('%Y-%m-%d')
      sponsor_params[:end_date] = Time.strptime(end_date, '%m/%d/%Y').strftime('%Y-%m-%d')
    end
    @sponsor = Sponsor.new(sponsor_params)

    respond_to do |format|
      if @sponsor.save
        format.html { redirect_to sponsors_url, notice: 'Sponsor has been successfully created.' }
        #format.html { redirect_to @sponsor, notice: 'Sponsor was successfully created.' }
        #format.json { render :show, status: :created, location: @sponsor }
      else
        format.html { render :new }
        format.json { render json: @sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sponsors/1
  # PATCH/PUT /sponsors/1.json
  def update
    unless sponsor_params[:picture] == nil
      @sponsor.picture = sponsor_params[:picture]
      @sponsor.save(validate: false)
    end
    respond_to do |format|
      if params[:sponsor][:start_date].present? or params[:sponsor][:end_date].present?
        start_date = params[:sponsor][:start_date]
        end_date = params[:sponsor][:end_date]
        params[:sponsor][:start_date] = Time.strptime(start_date, '%m/%d/%Y').strftime('%Y-%m-%d')
        params[:sponsor][:end_date] = Time.strptime(end_date, '%m/%d/%Y').strftime('%Y-%m-%d')
      end

      if @sponsor.update(sponsor_params)
        format.html { redirect_to sponsors_path, notice: 'Sponsor has been successfully updated.' }
        format.json { render :show, status: :ok, location: @sponsor }
      else
        format.html { render :edit }
        format.json { render json: @sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sponsors/1
  # DELETE /sponsors/1.json
  def destroy
    @sponsor.destroy
    respond_to do |format|
      format.html { redirect_to sponsors_url, notice: 'Sponsor has been successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def sponsor_type

  end

  def update_sponsor_type
    @sponsor_type = SponsorType.find(params[:id])
    respond_to do |format|
      if @sponsor_type.update_attributes(sp_fields_params)
        format.html { redirect_to sp_fees_path, notice: 'Updated Successfully' }
      else
        format.html { redirect_to sp_fees_path, notice: 'Not Updated' }
      end
    end
  end
  
  def upload
    FileUtils.rm Dir.glob('public/tmp/*.*')
    render :json => {path: DataFile.save(params["sponsor"]['picture'])}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sponsor
      @sponsor = Sponsor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sponsor_params
      params.require(:sponsor).permit(:name, :address, :nation, :city, :state, :zip, :phone, :email, :website, :mobile_phone_number, :contact_last_name, :contact_first_name, :sponsor_ship_type, :message, :picture, :sponsortype, :county, :messagefee, :company_id, :start_date, :end_date)
    end
end
