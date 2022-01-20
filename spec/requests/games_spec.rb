require 'rails_helper'

RSpec.describe "Games", type: :request do
  let!(:game) { create(:game) }
  let(:user) { create(:user) }
  let(:user_with_icon) { create(:user_with_icon) }

  describe "GET #index" do
    before do
      get root_path
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(200)
    end

    it "レスポンスにゲーム名が含まれること" do
      expect(response.body).to include game.name
    end

    context "ログインしていない場合" do
      it "レスポンスに「ログイン」・「新規登録」が含まれること" do
        expect(response.body).to include "ログイン"
        expect(response.body).to include "新規登録"
      end
    end

    context "ログインしている場合" do
      context "アイコン画像未登録の場合" do
        it "レスポンスにユーザー名とアイコン画像が含まれること" do
          sign_in user
          get root_path
          expect(response.body).to include user.name
          expect(response.body).to include "default_icon"
        end
      end

      context "アイコン画像登録済みの場合" do
        it "レスポンスにユーザー名とアイコン画像が含まれること" do
          sign_in user_with_icon
          get root_path
          expect(response.body).to include user_with_icon.name
          expect(response.body).to include "test.jpeg"
        end
      end

      it "レスポンスに「ユーザー情報の編集」・「ログアウト」が含まれること" do
        sign_in user
        get root_path
        expect(response.body).to include "ユーザー情報の編集"
        expect(response.body).to include "ログアウト"
      end
    end
  end
end
