require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "バリデーション" do
    it "チャット本文、user_id、game_idがあれば有効であること" do
      user = create(:user)
      game = create(:game)
      post = build(:post, user_id: user.id, game_id: game.id)
      expect(post).to be_valid
    end

    it "チャット本文がなければ無効であること" do
      post = build(:post, text: nil)
      post.valid?
      expect(post.errors[:text]).to include "can't be blank"
    end

    it "user_idがなければ無効であること" do
      post = build(:post, user_id: nil)
      post.valid?
      expect(post.errors[:user_id]).to include "can't be blank"
    end

    it "game_idがなければ無効であること" do
      post = build(:post, game_id: nil)
      post.valid?
      expect(post.errors[:game_id]).to include "can't be blank"
    end
  end
end
