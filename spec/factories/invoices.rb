# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    title "MyString"
    amount ""
    ids "MyText"
    start_date "2014-09-16"
    end_date "2014-09-16"
  end
end
