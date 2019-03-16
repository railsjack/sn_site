class FamilymembersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_family_member, only: [:show, :edit, :update, :destroy]

  # GET /family_members
  # GET /family_members.json
  def index
    if current_user.admin?
      @profiles = Profile.where(user_type: Profile.user_types[:family_member])
      @lovedone_count = Lovedone.all.count
    else
      @profiles = []
      current_user.lovedones.first.followers.each do |follower|
        @profiles << follower.user.profile
      end
      @lovedone_count = current_user.lovedones.count
    end
  end

  # GET /family_members/1
  # GET /family_members/1.json
  def show
  end

  # GET /family_members/new
  def new
    @family_member = User.new
    if current_user.admin?
      @lovedones = Lovedone.all
    else
      @lovedones = current_user.lovedones
    end
  end

  # GET /family_members/1/edit
  def edit
    @family_member = User.find(params[:id])
    if current_user.admin?
      @lovedones = Lovedone.all
    else
      @lovedones = current_user.lovedones
    end
  end

  # POST /family_members
  # POST /family_members.json
  def create
    $lovedone = nil
    @family_member = User.new(family_member_params)
    @family_member.profile.user_type = Profile.user_types[:family_member]
    respond_to do |format|
      if @family_member.save
        unless family_member_params_for_lovedone[:lovedones].blank?
          follower = Follower.new user_id: @family_member.id, request_status: "invited", 
            lovedone_id: family_member_params_for_lovedone[:lovedones]
          follower.save
        end
        @family_member.send_on_create_confirmation_instructions_ex
        format.html { redirect_to familymembers_path, notice: 'Family member was successfully created.' }
        #format.json { render :show, status: :created, location: @family_member }
      else
        if current_user.admin?
          @lovedones = Lovedone.all
        else
          @lovedones = current_user.lovedones
        end
        format.html { render :new }
        format.json { render json: @family_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /family_members/1
  # PATCH/PUT /family_members/1.json
  def update
    $lovedone = nil
    @family_member = User.find(params[:id])
    params = family_member_params
    profile_params = params[:profile_attributes]

    profile = Profile.find(@family_member.profile.id)
    params[:profile_attributes][:user_type] = '1'

    respond_to do |format|
      if profile.update(profile_params)

        # check if lovedone_id is changed now...
        if request.params[:prev_lovedone_id]!=family_member_params_for_lovedone[:lovedones]
          follower = Follower.find_by(user_id: @family_member.id,
            lovedone_id: request.params[:prev_lovedone_id])
          follower.destroy unless follower.nil?

          unless family_member_params_for_lovedone[:lovedones].blank?
            follower = Follower.new user_id: @family_member.id, request_status: "invited", 
              lovedone_id: family_member_params_for_lovedone[:lovedones]
            follower.save
          end
        end

        if params.include?(:email)
          @family_member.skip_confirmation!
          @family_member.skip_confirmation_notification!
          @family_member.confirm!
          @family_member.update_attribute(:email, params[:email])
          @family_member.save
        end



        format.html { redirect_to familymembers_path, notice: 'Family member was successfully updated.' }
        format.json { render :show, status: :ok, location: @family_member }
      else
        format.html { render :edit }
        format.json { render json: @family_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /family_members/1
  # DELETE /family_members/1.json
  def destroy
    @family_member = User.find(params[:id])
    @family_member.destroy
    respond_to do |format|
      format.html { redirect_to familymembers_path, notice: 'Family member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_family_member
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_member_params
      params.require(:user).permit(:lastname, :firstname, :email, :mobilephone, :contact, :city, :county, :state, :username, :password,:password_confirmation,
        profile_attributes: [:first_name, :last_name, :phone_number, {:contact_method => []}, :city, :county, :state])
    end

    def family_member_params_for_lovedone
      params.require(:user).permit(
        :lovedones)
    end

    def sign_up_params
      devise_parameter_sanitizer.sanitize(:sign_up)
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms, 
        profile_attributes: [:first_name, :last_name, :phone_number, {:contact_method => []}, :city, :county, :state],
        )
    end

end
