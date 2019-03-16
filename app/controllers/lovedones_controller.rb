class LovedonesController < ApplicationController

  before_filter :authenticate_user!    
  before_action :set_lovedone, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
    
  # GET /lovedones
  # GET /lovedones.json
  def index
    authorize! :read, Lovedone

    if current_user.admin?
      @lovedones_all = Lovedone.all
      # @primarycontacts = PrimaryContact.all
      @following_followers = Follower.where("request_status LIKE 'approved'" )  
      @invited_followers = Follower.where("request_status LIKE 'invited'" )  
    else
      @lovedones_all = Lovedone.all
      @lovedones = current_user.company.lovedones

      @following_followers = Follower.where("user_id = ? AND request_status LIKE 'approved'" , current_user.id)
      @invited_followers = Follower.where("user_id = ? AND request_status LIKE 'invited'" , current_user.id)  
    end
  end

  def lovedone_selection
    @lovedones = current_user.company.lovedones
  end

  def refresh
      # @primarycontacts = PrimaryContact.where("user_id = ?", current_user.id)
      @following_followers = Follower.where("user_id = ? AND request_status = 'approved'" , current_user.id)  
      @invited_followers = Follower.where("user_id = ? AND request_status = 'invited'" , current_user.id)  
  end      
  # GET /lovedones/1
  # GET /lovedones/1.json
  def show
          #@users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])  
      #added for .js otherwise json and html were anyway supported
      #http://davidsulc.com/blog/2011/04/10/implementing-a-public-api-in-rails-3/
      @lovedone = Lovedone.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        #prevented by forgery protection
        format.js  { render :json => @lovedone, :callback => params[:callback] }
        format.json  { render :json => @lovedone }
        format.xml  { render :xml => @lovedone }
      end
      
  end

  # GET /lovedones/new
  def new
    @lovedone = Lovedone.new
    @current_user = User.find(session["warden.user.user.key"][0][0])
    # @lovedone.build_primary_contact(user_id: @current_user)
    # @lovedone.primary_contact.user_id = @current_user.id
    #@lovedone.primary_contact.build_primary_contact
    #@lovedone.primary_contact.user_id = @current_user  
      #@users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])  
      
  end

  # GET /lovedones/1/edit
  def edit
    @users = User.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])  
    @featured_companies = Company.featured
    @transports = Company.transports
    @home_healths = Company.home_healths
    # @primary_contact_users = []
    # User.all.each do |user|
    #   @primary_contact_users << user if user.primary_contact?
    # end
  end

  # GET /lovedones/1/invite/:user_id
  def invite
      puts params[:user_ids]
  end
    #POST lovedone/:id/invite/:user_id
    def updateinvite
    end 
    
  # POST /lovedones
  # POST /lovedones.json
  def create
    @lovedone = Lovedone.new(lovedone_params)
    @current_user = User.find(session["warden.user.user.key"][0][0])
    @lovedone.company_id = @current_user.company.id
    # @primary_contact = @lovedone.create_primary_contact(user_id: @current_user)
    #@primary_contact.user_id = @current_user  
    # @lovedone.primary_contact.user_id = @current_user.id
    #@lovedone.primary_contact_id = @current_user.id  
    respond_to do |format|
      if @lovedone.save
        format.html { redirect_to lovedones_path, notice: 'Loved one has been successfully created.' }
        format.json { render :show, status: :created, location: @lovedone }
        #http://stackoverflow.com/questions/10338692/how-can-i-find-a-devise-user-by-its-session-id  
        #@current_user = User.find(session["warden.user.user.key"][0][0])
        #@lovedone.make_primary!(@current_user)  
      else
        format.html { render :new }
        format.json { render json: @lovedone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lovedones/1
  # PATCH/PUT /lovedones/1.json
  def update
    respond_to do |format|
      if @lovedone.update(lovedone_params)
        format.html { redirect_to lovedones_path, notice:  'Loved one has been successfully updated.'}
        format.json { render :show, status: :ok, location: @lovedone }
      else
        format.html { render :edit }
        format.json { render json: @lovedone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lovedones/1
  # DELETE /lovedones/1.json
  def destroy
    @lovedone.destroy
    respond_to do |format|
      #refresh    
      format.html { redirect_to lovedones_url, notice: 'Loved one has been successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def set_provders
    
  end


  # /lovedones/:id/newprimary    
  def change_primary
      
  end 


  # /lovedones/import_bulkdata
  def import_bulkdata
    @service_providers = Company.all
  end

  def import
    service_provider_id = params[:service_provider]
    formats = [".csv", ".xls", ".xlsx"]
    if formats.include?(File.extname(params[:file].original_filename))
      lovedones = Lovedone.import(params[:file], service_provider_id)
      redirect_to lovedones_path, notice: 'Loved One Imported Successfully.'
    else
      redirect_to import_lovedones_path, alert: 'Unknown File Format'
    end
  end


  # def assign_primary_contact
  #   lovedone_id = params[:lovedone_id]
  #   user_id = params[:user_id]
  #
  #   lovedone = Lovedone.find(lovedone_id)
  #   primary_contact = PrimaryContact.new lovedone_id: lovedone.id, user_id: user_id
  #   primary_contact.save
  #
  #   lovedone.primary_contact_id = primary_contact.id
  #   lovedone.save
  #   redirect_to :back
  # end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lovedone
      @lovedone = Lovedone.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lovedone_params
      params.require(:lovedone).permit(:last_name, :first_name, :middle_initial, :nick_name, :date_of_birth, :phone_number, :email, :setting, :gender, :apt_unit, :street, :city, :county, :state, :zip_code)
    end
    

  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end    
end
