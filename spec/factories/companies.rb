# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    company_name "MyString"
    business_name "MyString"
    provider_type "MyString"
    telephone "MyString"
    mobile_phone_number "MyString"
    get_notification false
    user_id 1
    address "MyString"
    city "MyString"
    country "MyString"
    state "MyString"
    zip "MyString"
    contact_last_name "MyString"
    contact_first_name "MyString"
  end
end
