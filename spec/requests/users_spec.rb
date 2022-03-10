require 'rails_helper'

RSpec.describe "Users" do
  describe "Sessions" do
    describe "POST #guest_sign_in" do
      let(:user) { create(:user) }
      let(:user_params) { attributes_for(:user) }

      it "リクエストが成功すること" do
        post users_guest_sign_in_path, params: { user: user_params }
        expect(response).to have_http_status(302)
      end

      it "データベースへの保存が成功すること" do
        expect do
          post users_guest_sign_in_path, params: { user: user_params }
        end.to change { User.count }.by(1)
      end

      it "リダイレクトされること" do
        post users_guest_sign_in_path, params: { user: user_params }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #show" do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:user_with_icon) { create(:user, :with_icon) }
    let(:another_game) { create(:another_game) }
    let!(:user_post) { create(:post, user: user) }
    let!(:liked_post) { create(:post, :another, game: another_game, user: another_user) }
    let!(:like) { create(:like, post: liked_post, user: user) }

    before do
      sign_in user
    end

    context "アイコン画像未登録の場合" do
      before do
        get user_path(user)
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "ユーザーの名前・紹介文・デフォルトのアイコン画像が表示されること" do
        expect(response.body).to include user.name
        expect(response.body).to include user.introduction
        expect(response.body).to include "default_icon"
      end

      it "投稿したチャット一覧がレスポンスに含まれること" do
        expect(response.body).to include "#{user_post.game.name}#{user_post.game.purpose}掲示板"
        expect(response.body).to include user_post.text
        expect(response.body).to include user_post.created_at.to_s(:datetime)
      end

      it "いいねしたチャット一覧がレスポンスに含まれること" do
        expect(response.body).to include liked_post.user.name
        expect(response.body).to include "#{liked_post.game.name}#{liked_post.game.purpose}掲示板"
        expect(response.body).to include liked_post.text
        expect(response.body).to include liked_post.created_at.to_s(:datetime)
      end
    end

    context "アイコン画像登録済みの場合" do
      it "ユーザーの名前・紹介文・アイコン画像が表示されること" do
        get user_path(user_with_icon)
        expect(response.body).to include user_with_icon.name
        expect(response.body).to include user_with_icon.introduction
        expect(response.body).to include "test.jpg"
      end
    end
  end
end
