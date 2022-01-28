FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "testuser" }

    trait :with_icon do
      icon { Rack::Test::UploadedFile.new("#{Rails.root}/spec/factories/test.jpg", "image/jpeg") }
    end

    trait :guest do
      email { "guest@example.com" }
    end
  end
end
