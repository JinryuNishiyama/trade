FactoryBot.define do
  factory :post do
    association :user
    association :game
    text { "テスト用チャットです。" }

    trait :invalid do
      text { nil }
    end
  end

  factory :another_post, class: "Post" do
    association :user
    association :game
    text { "別のテスト用チャットです。" }
  end
end
