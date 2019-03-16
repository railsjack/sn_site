# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :employee do
    latitude 1.5
    longitude 1.5
    company nil
    lovedone nil
    name "MyString"
    username "MyString"
    password "MyString"
  end
end
