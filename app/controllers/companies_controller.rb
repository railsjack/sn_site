class CompaniesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    #company_params_copy = company_params      
    #@new_status = company_params[:status] == "true"
    #company_params_copy[:status] = @new_status
      
    @company = Company.new(company_params)
    #@company = Company.new(company_params_copy)  

    respond_to do |format|
      if @company.save
        unless current_user.admin?
          format.html { redirect_to @company, notice: 'Company has been successfully created.' }
          format.json { render :show, status: :created, location: @company }
        else
          format.html { redirect_to admin_providers_path, notice: 'Company has been successfully created.' }
          format.json { render :show, status: :created, location: @company }
        end
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      #company_params_copy = company_params      
      #@new_status = company_params[:status] == "1" ? 1 : 0
      #@new_status = company_params[:status] == "true"    
      #company_params_copy[:status] = @new_status
        
      #if @company.update(company_params_copy)
      if @company.update(company_params)    
        #format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        if company_params[:status]=="approved"
          unless @company.user==nil
            SystemMailer.approveapp_email(@company.user.email).deliver
            @company.user.confirm!
          end
        end
        flash.now[:notice] = 'Company was successfully updated.'
        format.html { render :edit }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companymembers_path, notice: 'Company has been successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def lovedones
    @company = Company.find(params[:id])
    # ids = @company.providers.pluck('lovedone_id')
    # @lovedones = Lovedone.where(id: ids).order(:last_name)
    @lovedones = @company.lovedones.order(:last_name)
    render json: {lovedones: @lovedones.all}
  end

  def active_lovedones
    @company = Company.find(params[:id])
    # ids = @company.providers.pluck('lovedone_id')
    # @lovedones = Lovedone.where(id: ids)
    @lovedones = @company.lovedones
    @active_trips = Trip.where(status: ['active', 'started']).all.pluck('id, lovedone_id, status, employee_id')

    @active_lovedones = []
    @lovedones.each do |lovedone|
      selected_trips = @active_trips.select{|trip| trip[1] == lovedone.id}
      if selected_trips.size()>0
        selected_trip = selected_trips.first
        trip = Trip.find(selected_trip[0])
        employee = trip.employee unless trip.nil?
        @active_lovedones << {
          lovedone: lovedone, 
          status: selected_trip[2], 
          trip_id: selected_trip[0], 
          employee_id: selected_trip[3],
          employee: employee
        }
      end
    end
    render json: {active_lovedones: @active_lovedones}
  end

  def employees_within
    nmiles = params[:nmiles]
    @employees = @company.employees_within(nmiles)

    respond_to do |format|
      format.json
    end
  end

  def employee_lovedones
    if params[:employee_lovedone]
      @employee = Employee.find_by_id(params[:employee_lovedone][:employee_id])
      params[:employee_lovedone][:lovedone_id].delete("")
      if params[:employee_lovedone][:lovedone_id].present? and params[:employee_lovedone][:employee_id].present?
        if (@employee.assigned_lovedone_ids.collect { |lo| lo.to_s } + params[:employee_lovedone][:lovedone_id]).uniq.length <= 1000
          @employee.assigned_lovedone_ids += params[:employee_lovedone][:lovedone_id]
          PushNotificationService.push_notification(@employee)
          redirect_to employee_lovedones_path(params[:id], emp_id: params[:employee_lovedone][:employee_id])
        else
          redirect_to employee_lovedones_path(params[:id], emp_id: params[:employee_lovedone][:employee_id]), notice: 'This Employee can be restricted to 5 Loved Ones only'
        end
      else
        redirect_to employee_lovedones_path(params[:id], emp_id: params[:employee_lovedone][:employee_id]), notice: 'Please select Loved Ones'
      end
    end

    @employee_lovedone = EmployeeLovedone.new
    company = Company.find(params[:id])
    @employees = company.employees.order('last_name ASC').includes(:assigned_lovedones)
    @lovedones = company.lovedones.order('last_name ASC')
    # @employee_lovedones = EmployeeLovedone.all.includes(:employee, :lovedone)
  end

  def employee_lovedone
    EmployeeLovedone.find_by_employee_id_and_lovedone_id(params[:employee_id],params[:id]).delete
    @employee = Employee.find(params[:employee_id])
    PushNotificationService.push_notification(@employee)
    redirect_to employee_lovedones_path(params[:company_id], emp_id: params[:employee_id])
  end

  def restricted_lovedones
    @employee = Employee.find_by_id(params[:emp_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def check_login
    redirect_to root_path if current_user.nil?
  end

  def set_company
    @company = Company.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:company_name, :business_name, :provider_type,
      :telephone, :mobile_phone_number, :get_notification, :user_id,
      :address, :city, :county, :state, :zip, :contact_last_name, :contact_first_name,
      {:contact_method=>[]}, :status, :email, :latitude, :longitude, :notification_masking, :lovedone_masking)
  end
end
