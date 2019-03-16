FactoryGirl.define do
  factory :fee do
    company_id 1
base_fee 1.5
base_fee_status false
employee_fee 1.5
employee_fee_status false
reach_out_fee 1.5
reach_out_status false
transfer_fee 1.5
transfer_fee_status false
  end

end
