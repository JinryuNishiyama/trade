FactoryBot.define do
  factory :game do
    name { "テストゲーム" }
    purpose { "テスト" }
    description { "テスト用説明文です。" }
    association :user

    trait :with_post do
      sequence(:name) { |n| "チャット付きゲーム#{n}" }
      after(:create) do |game|
        create(:post, game: game)
      end
    end

    trait :invalid do
      name { nil }
    end
  end

  factory :game_after_change, class: "Game" do
    name { "変更後ゲーム" }
    purpose { "テスト" }
    description { "テスト用説明文です。" }
    association :user

    trait :invalid do
      name { nil }
    end
  end

  factory :another_game, class: "Game" do
    name { "別のゲーム" }
    purpose { "別のテスト" }
    description { "別のテスト用説明文です。" }
    association :user
  end
end
