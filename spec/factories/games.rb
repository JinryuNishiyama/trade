FactoryBot.define do
  factory :game do
    association :user
    name { "テストゲーム" }
    purpose { "テスト" }
    description { "テスト用説明文です。" }

    trait :invalid do
      name { nil }
    end
  end
end
