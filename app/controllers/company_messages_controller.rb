class CompanyMessagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :setup_params
  def index
  	@all_messages = @company.company_messages.order('updated_at DESC')
  end

  def new
    # @categories = Designation::categories
    @designations = @company.designations

    # @current_company.designations.each do |category|
    #   flag = false
    #   @categories.each do |category1|
    #     if category1[0] == category.name
    #       flag = true
    #       category1[0] = category.id
    #       break
    #     end
    #   end
    #   @categories << [category.id, category.name] unless flag
    # end
    
    @company_message = @current_company.company_messages.build
    @company_message.company_message_employees.build
  end

  def edit
    @company_message = CompanyMessage.find(params[:id])
  end

  def create
    params = messages_params.except :company_message_employees
		company_message = @company.company_messages.new(params)
    if company_message.save
      company_message_employees = messages_params[:company_message_employees]
      unless company_message_employees.nil?
        company_message_employees.each do |employee_id|
          next if employee_id.blank?
          company_message.company_message_employees.create(employee_id: employee_id)
        end
      end
      redirect_to new_company_company_message_path, notice: 'The message has been sent successfully.'
    else
      redirect_to new_company_company_message_path
    end
    
  	
  end

  def update
    @company_message = CompanyMessage.find(params[:id])
    @company_message.update(messages_params)
    redirect_to company_company_messages_path
  end

  def destroy
  	CompanyMessage.destroy(params[:id])
  	redirect_to :back
  end


  private
  def setup_params
    @company_id = params[:company_id]
    @company = Company.find(@company_id)
    @current_company = @company
  end

  def messages_params
    params.require(:company_message).permit(:message, {:company_message_employees=>[]}, :address)
  end
end
