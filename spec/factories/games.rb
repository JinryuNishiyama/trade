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

  factory :game_after_change, class: "Game" do
    association :user
    name { "変更後テストゲーム" }
    purpose { "テスト" }
    description { "テスト用説明文です。" }

    trait :invalid do
      name { nil }
    end
  end

  factory :another_game, class: "Game" do
    association :user
    name { "別のテストゲーム" }
    purpose { "別のテスト" }
    description { "別のテスト用説明文です。" }
  end
end
