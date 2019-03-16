class InvoicesController < ApplicationController
	before_filter :authenticate_user!
  def create
  	if current_user.admin?
	  	@invoice = Invoice.new invoice_params
	  	if @invoice.save
				sender = current_user
	  		SystemMailer.invoice_email(@invoice, sender).deliver
	  	end
	  end
  end

  def invoice_params
    params.require(:invoice).permit(:title, :amount, :ids, :start_date, :end_date, :message_count, :sponsor_id, :ids)
  end
end
