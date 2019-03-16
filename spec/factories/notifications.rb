# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    employee nil
    lovedone nil
    status "MyString"
    notification_type "MyString"
  end
end
