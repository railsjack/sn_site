# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :follower do
    user nil
    lovedone nil
    request_status "MyString"
  end
end
