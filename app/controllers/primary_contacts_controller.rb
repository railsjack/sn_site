class PrimaryContactsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_primary_contact, only: [:show, :edit, :update, :destroy]

  # GET /primary_contacts
  # GET /primary_contacts.json
  def index
    @primary_contacts = PrimaryContact.all
  end

  # GET /primary_contacts/1
  # GET /primary_contacts/1.json
  def show
  end

  # GET /primary_contacts/new
  def new
    @primary_contact = PrimaryContact.new
  end

  # GET /primary_contacts/1/edit
  def edit
  end

  # POST /primary_contacts
  # POST /primary_contacts.json
  def create
    @primary_contact = PrimaryContact.new(primary_contact_params)

    respond_to do |format|
      if @primary_contact.save
        format.html { redirect_to @primary_contact, notice: 'Primary contact was successfully created.' }
        format.json { render :show, status: :created, location: @primary_contact }
      else
        format.html { render :new }
        format.json { render json: @primary_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /primary_contacts/1
  # PATCH/PUT /primary_contacts/1.json
  def update
    respond_to do |format|
      if @primary_contact.update(primary_contact_params)
        #format.html { redirect_to @primary_contact, notice: 'Primary contact was successfully updated.' }
        #not edit as user is no more the primary conatc  
        #format.html { redirect_to @lovedone, notice: 'Primary contact was successfully updated.' }  
        #go to index page
        format.html { redirect_to lovedones_path, notice: 'Primary contact was successfully updated.' }    
        format.json { render :show, status: :ok, location: @primary_contact }
      else
        format.html { render :edit }
        format.json { render json: @primary_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /primary_contacts/1
  # DELETE /primary_contacts/1.json
  def destroy
    @primary_contact.destroy
    respond_to do |format|
      format.html { redirect_to admin_primary_contacts_path, notice: 'Primary contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_primary_contact
      #puts "@user_profiles"    
      @user_profiles = User.users_with_profile.all
      #puts @user_profiles    
      @lovedone = Lovedone.find(params[:lovedone_id])
      @primary_contact = PrimaryContact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def primary_contact_params
      #params[:primary_contact]
      params.require(:primary_contact).permit(:user_id, :lovedone_id)
    end
end
