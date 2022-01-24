FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "testuser" }
  end

  factory :user_with_icon, class: "User" do
    name { "テストユーザー" }
    icon { Rack::Test::UploadedFile.new("#{Rails.root}/spec/factories/test.jpg", "image/jpeg") }
    sequence(:email) { |n| "icon-test#{n}@example.com" }
    password { "testuser" }
  end
end
