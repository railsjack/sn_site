# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip do
    employee nil
    lovedone nil
    status "MyString"
    state "MyString"
    latitude 1.5
    longitude 1.5
  end
end
