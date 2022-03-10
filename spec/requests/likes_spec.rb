require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:post_in_game) { create(:post, game: game) }

  before do
    sign_in user
  end

  describe "POST #create" do
    it "リクエストが成功すること" do
      post game_post_likes_path(game, post_in_game), xhr: true
      expect(response).to have_http_status(200)
    end

    it "データベースへの保存が成功すること" do
      expect do
        post game_post_likes_path(game, post_in_game), xhr: true
      end.to change { Like.count }.by(1)
    end
  end

  describe "DELETE #destroy" do
    let!(:like) { create(:like, post: post_in_game, user: user) }

    it "リクエストが成功すること" do
      delete game_post_likes_path(game, post_in_game), xhr: true
      expect(response).to have_http_status(200)
    end

    it "データベースへの保存が成功すること" do
      expect do
        delete game_post_likes_path(game, post_in_game), xhr: true
      end.to change { Like.count }.by(-1)
    end
  end
end
