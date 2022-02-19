FactoryBot.define do
  factory :post do
    text { "テスト用チャットです。" }
    association :game
    association :user

    trait :invalid do
      text { nil }
    end
  end

  factory :another_post, class: "Post" do
    text { "別のチャットです。" }
    association :game
    association :user
  end
end
