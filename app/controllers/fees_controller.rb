class FeesController < ApplicationController

  def sp
  end

  def sponsor
  end

  def sponsor_fees_fields
    @sponsor = Sponsor.find(params[:sponsor_id])
    respond_to do |format|
      format.js
    end
  end

  def update_sponsor_fees_fields
    @sponsor = Sponsor.find(params[:id])
    respond_to do |format|
      if @sponsor.update_attributes(sponsor_fields_params)
        format.html { redirect_to sponsor_fees_path, notice: 'Updated Successfully' }
      else
        format.html { redirect_to sponsor_fees_path, notice: 'Not Updated' }
      end
    end
  end

  def sp_fees_fields
    @company = Company.find(params[:company_id])
    if @company.fee.nil?
      @company.build_fee
    end
    respond_to do |format|
      format.js
    end
  end

  def update_sp_fees_fields
    @company = Company.find(params[:id])
    respond_to do |format|
      if @company.update_attributes(sp_fields_params)
        month = Time.now.month
        year = Time.now.year
        monthly_billing = MonthlyBilling.where(company: @company, month: month, year: year)
        if monthly_billing.count > 0
          monthly_billing = monthly_billing.first
          company_fee = @company.fee
          total_reach_outs_fee = total_employees_fee = total_transfers_fee = total_base_fee = 0
          total_base_fee = company_fee.base_fee.present? ? company_fee.base_fee : 0 if company_fee.base_status
          total_reach_outs_fee = company_fee.reach_out_fee.present? ? monthly_billing.reach_out_count * company_fee.reach_out_fee : 0 if company_fee.reach_out_status
          total_employees_fee = company_fee.employee_fee.present? ? monthly_billing.employees_count * company_fee.employee_fee : 0 if company_fee.employee_status
          total_transfers_fee = company_fee.transfer_fee.present? ? monthly_billing.transfer_count * company_fee.transfer_fee : 0 if company_fee.transfer_status
          total_amount_due = total_reach_outs_fee + total_employees_fee + total_transfers_fee + total_base_fee
          monthly_billing.update(reach_out_fee: total_reach_outs_fee, transfer_fee: total_transfers_fee, employee_fee: total_employees_fee, base_fee: total_base_fee, amount_due: total_amount_due)
        end
        format.html { redirect_to sp_fees_path, notice: 'Updated Successfully' }
      else
        format.html { redirect_to sp_fees_path, notice: 'Not Updated' }
      end
    end
  end

  private

    def sp_fields_params
      params.require(:company).permit(fee_attributes: [:base_fee, :employee_fee, :reach_out_fee, :transfer_fee, :base_status, :employee_status, :reach_out_status, :transfer_status, :id])
    end

    def sponsor_fields_params
      params.require(:sponsor).permit(:employee_notice_fee, :transfer_fee, :transfer_status, :employee_notice_status)
    end

end
