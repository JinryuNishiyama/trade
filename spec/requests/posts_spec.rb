require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }

  describe "POST #create" do
    let(:post_params) { attributes_for(:post) }
    let(:invalid_post_params) { attributes_for(:post, :invalid) }

    before do
      sign_in user
    end

    context "パラメータが有効である場合" do
      it "リクエストが成功すること" do
        post game_posts_path(game), params: { post: post_params }
        expect(response).to have_http_status(302)
      end

      it "データベースへの保存が成功すること" do
        expect do
          post game_posts_path(game), params: { post: post_params }
        end.to change { Post.count }.by(1)
      end

      it "リダイレクトされること" do
        post game_posts_path(game), params: { post: post_params }
        expect(response).to redirect_to game_path(game)
      end
    end

    context "パラメータが無効である場合" do
      it "リクエストが成功すること" do
        post game_posts_path(game), params: { post: invalid_post_params }
        expect(response).to have_http_status(200)
      end

      it "データベースに保存されないこと" do
        expect do
          post game_posts_path(game), params: { post: invalid_post_params }
        end.not_to change { Post.count }
      end

      it "エラーメッセージが表示されること" do
        post game_posts_path(game), params: { post: invalid_post_params }
        expect(response.body).to include "投稿できませんでした"
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:post) { create(:post) }

    before do
      sign_in user
    end

    it "リクエストが成功すること" do
      delete game_post_path(game, post)
      expect(response).to have_http_status(302)
    end

    it "チャットが削除されること" do
      expect do
        delete game_post_path(game, post)
      end.to change { Post.count }.by(-1)
    end

    it "リダイレクトされること" do
      delete game_post_path(game, post)
      expect(response).to redirect_to game_path(game)
    end
  end
end
