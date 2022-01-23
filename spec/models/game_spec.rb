require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "バリデーション" do
    it "ゲーム名、目的、説明文、user_idがあれば有効であること" do
      user = create(:user)
      game = build(:game, user_id: user.id)
      expect(game).to be_valid
    end

    it "ゲーム名がなければ無効であること" do
      game = build(:game, name: nil)
      game.valid?
      expect(game.errors[:name]).to include "can't be blank"
    end

    it "目的がなければ無効であること" do
      game = build(:game, purpose: nil)
      game.valid?
      expect(game.errors[:purpose]).to include "can't be blank"
    end

    it "説明文がなければ無効であること" do
      game = build(:game, description: nil)
      game.valid?
      expect(game.errors[:description]).to include "can't be blank"
    end

    it "user_idがなければ無効であること" do
      game = build(:game, user_id: nil)
      game.valid?
      expect(game.errors[:user_id]).to include "can't be blank"
    end
  end
end
