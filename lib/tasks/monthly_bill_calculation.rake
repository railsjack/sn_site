namespace :monthly_bill_calculation do
  task create_monthly_bill: :environment do

    Company.all.each do |company|
      if company.fee.present?
        company_fee = company.fee
        month = Time.now.month
        year = Time.now.year
        month_bill = MonthlyBilling.where(company: company, month: month, year: year)
        if month_bill.count.eql? 0
          total_employees = company.employees
          total_appointment_transfers = company.appointment_transfers.where("DATE_FORMAT(created_at, '%m-%Y')=? and transfer_type=?", (Time.now - 1.month).strftime('%m-%Y'), 0)
          total_reachouts = company.company_messages.where("DATE_FORMAT(created_at, '%m-%Y')=?", (Time.now - 1.month).strftime('%m-%Y'))
          total_reach_outs_fee = total_employees_fee = total_transfers_fee = total_base_fee = 0
          total_base_fee = company_fee.base_fee.present? ? company_fee.base_fee : 0 if company_fee.base_status
          total_reach_outs_fee = company_fee.reach_out_fee.present? ? total_reachouts.count * company_fee.reach_out_fee : 0 if company_fee.reach_out_status
          total_employees_fee = company_fee.employee_fee.present? ? total_employees.count * company_fee.employee_fee : 0 if company_fee.employee_status
          total_transfers_fee = company_fee.transfer_fee.present? ? total_appointment_transfers.count * company_fee.transfer_fee : 0 if company_fee.transfer_status
          total_amount_due = total_reach_outs_fee + total_employees_fee + total_transfers_fee + total_base_fee
          begin
            MonthlyBilling.create(
                company: company,
                month: month,
                year: year,
                employees_count: total_employees.count,
                reach_out_count: total_reachouts.count,
                transfer_count: total_appointment_transfers.count,
                employee_ids: total_employees.pluck(:id),
                base_fee: total_base_fee,
                employee_fee: total_employees_fee,
                reach_out_fee: total_reach_outs_fee,
                transfer_fee: total_transfers_fee,
                amount_due: total_amount_due
            )
            p "Monthly bill for #{company.business_name} with id: #{company.id} has been created successfully with total #{total_employees.count} employees."
          rescue Exception => e
            p e.message
          end
        else
          p "Monthly bill for #{company.business_name} with id: #{company.id} already exists"
        end
      else
        p "No fee structure found for the #{company.business_name} with id: #{company.id}"
      end
    end

  end
end
