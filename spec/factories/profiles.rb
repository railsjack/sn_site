# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    last_name "MyString"
    first_name "MyString"
    middle_initial "MyString"
    nick_name "MyString"
    dob "2014-06-19"
    gender "MyString"
    address "MyString"
    city "MyString"
    country "MyString"
    state "MyString"
    zip "MyString"
    code "MyString"
    contact_method "MyString"
  end
end
