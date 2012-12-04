# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reply do
    comment_id 1
    text "MyString"
    user_id 1
  end
end
