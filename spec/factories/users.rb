FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "testuser" }
    introduction { "テストユーザーの紹介文です。" }

    trait :invalid do
      email { nil }
    end

    trait :with_icon do
      icon { Rack::Test::UploadedFile.new("#{Rails.root}/spec/factories/test.jpg", "image/jpeg") }
    end

    trait :guest do
      email { "guest@example.com" }
    end

    trait :admin do
      admin { true }
    end
  end
end
