FactoryBot.define do
  factory :post do
    text { "テスト用チャットです。" }
    association :game
    association :user

    trait :invalid do
      text { nil }
    end

    trait :another do
      text { "別のチャットです。" }
    end

    trait :with_reply_to do
      text { ">>1テスト用返信チャットです。" }
    end
  end
end
