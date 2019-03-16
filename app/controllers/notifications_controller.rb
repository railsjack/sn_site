class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.all
  end

  def calc
    @notification = Notification.new
    @fee = Setting.get_value('notification_fee')
  end

  def monthly_sp_billing
    month = params[:monthly_billing]['month(2i)']
    year = params[:monthly_billing]['year(1i)']
    @providers_monthly_billing = MonthlyBilling.where("amount_due>0.00 AND month=? AND year=?", month, year)

    respond_to do |format|
      format.js
    end
  end

  def calc_post
    if !params[:notification]['created_at(1i)'].nil?
      from = params[:notification]['created_at(1i)']+"-"+params[:notification]['created_at(2i)']+"-"+params[:notification]['created_at(3i)']
      to = params[:notification]['updated_at(1i)']+"-"+params[:notification]['updated_at(2i)']+"-"+params[:notification]['updated_at(3i)']
      sponsor_id = params[:notification]['sponsor_id']
      unless sponsor_id.blank?
        redirect_to calc_notification_betweenx_notifications_path(from, to, sponsor_id) and return
      else
        redirect_to calc_notification_between_notifications_path(from, to) and return
      end
    end
  end

  def calc_between
    @notifications = Notification.all
    unless params[:sponsor_id].nil?
      sponsor_id = params[:sponsor_id]
      @notifications = @notifications.where(['sponsor_id = ? ', sponsor_id])
      @view_mode = 'sponsor_detail'
      @nohead = 'true'
      @sponsor = Sponsor.find(sponsor_id)
      @fee = 11
    else
      @view_mode = 'sponsor_list'
      @fee = Setting.get_value('notification_fee')
    end
    

    if @fee.nil?
      redirect_to :back, notice: "Please set the fee first from #{view_context.link_to('here', settings_url)}"
      return
    end
    @default_date1 = Date.today
    @default_date2= Date.today
    if !params[:from].nil?
      from = params[:from]
      to = params[:to]
      @default_date1 = Date::strptime(from, '%Y-%m-%d')
      @default_date2 = Date::strptime(to, '%Y-%m-%d')
      @notifications = Notification.where(['created_at between ? and ?', from, to+' 23:59:59'])
    else
      @notifications = Notification.all
    end



    @from = from
    @to = to
    @notification = Notification.new


    _notifications = {}
    @notifications.each do |notification|
      if _notifications["sponsor_#{notification.sponsor_id}"].nil?
        temp = {ids: "", message_count: 0, sponsor_id: ''}
      else
        temp = _notifications["sponsor_#{notification.sponsor_id}"]
      end
      
      temp[:ids] += ","+ notification.id.to_s
      temp[:message_count] += 1
      temp[:sponsor_id] = notification.sponsor_id
      _notifications["sponsor_#{notification.sponsor_id}"] = temp
    end

    @invoices = _notifications
    @invoice = Invoice.new

    render :calc
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      #params.require(:notification).permit(:employee_id, :lovedone_id, :status, :notification_type)
      params.require(:notification).permit!
    end
    def notification_params_for_calc
      #params.require(:notification).permit(:employee_id, :lovedone_id, :status, :notification_type)
      params.require(:notification).permit(:created_at, :updated_at, :sponsor_id)
    end
end
