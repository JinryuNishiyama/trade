require 'rails_helper'

RSpec.describe "Games", type: :request do
  let(:user) { create(:user) }
  let!(:game) { create(:game, user: user) }

  describe "GET #index" do
    let(:user_with_icon) { create(:user, :with_icon) }
    let!(:games_with_post) { create_list(:game, 6, :with_post) }

    before do
      get root_path
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(200)
    end

    it "掲示板のゲーム名が表示されること" do
      expect(response.body).to include games_with_post.first.name
    end

    it "チャットが一件もない掲示板のゲーム名が表示されないこと" do
      expect(response.body).not_to include game.name
    end

    it "6件目以降のゲーム名が表示されないこと" do
      expect(response.body).not_to include games_with_post.last.name
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
          expect(response.body).to include "test.jpg"
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

  describe "GET #new" do
    before do
      sign_in user
      get new_game_path
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    let(:game_params) { attributes_for(:game) }
    let(:invalid_game_params) { attributes_for(:game, :invalid) }

    before do
      sign_in user
    end

    context "パラメータが有効である場合" do
      it "リクエストが成功すること" do
        post games_path, params: { game: game_params }
        expect(response).to have_http_status(302)
      end

      it "データベースへの保存が成功すること" do
        expect do
          post games_path, params: { game: game_params }
        end.to change { Game.count }.by(1)
      end

      it "リダイレクトされること" do
        post games_path, params: { game: game_params }
        expect(response).to redirect_to root_path
      end
    end

    context "パラメータが無効である場合" do
      it "リクエストが成功すること" do
        post games_path, params: { game: invalid_game_params }
        expect(response).to have_http_status(200)
      end

      it "データベースに保存されないこと" do
        expect do
          post games_path, params: { game: invalid_game_params }
        end.not_to change { Game.count }
      end

      it "エラーが表示されること" do
        post games_path, params: { game: invalid_game_params }
        expect(response.body).to include "掲示板を作成できませんでした"
      end
    end
  end

  describe "GET #show" do
    let!(:post) { create(:post, game: game) }

    before do
      sign_in user
      get game_path(game)
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(200)
    end

    it "掲示板の情報が表示されること" do
      expect(response.body).to include game.name
      expect(response.body).to include game.purpose
      expect(response.body).to include game.description
    end

    it "チャットを投稿したユーザーの名前が表示されること" do
      expect(response.body).to include post.user.name
    end

    it "チャットの内容が表示されること" do
      expect(response.body).to include post.text
    end

    it "チャットの作成日時が表示されること" do
      expect(response.body).to include post.created_at.to_s(:datetime)
    end
  end

  describe "GET #edit" do
    before do
      sign_in user
      get edit_game_path(game)
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(200)
    end

    it "ゲーム名が表示されること" do
      expect(response.body).to include game.name
    end

    it "ページの用途が表示されること" do
      expect(response.body).to include game.purpose
    end

    it "ページの説明が表示されること" do
      expect(response.body).to include game.description
    end
  end

  describe "PATCH #update" do
    let(:game_params) { attributes_for(:game) }
    let(:invalid_game_params) { attributes_for(:game, :invalid) }
    let(:game_params_after_change) { attributes_for(:game_after_change) }
    let(:invalid_game_params_after_change) { attributes_for(:game_after_change, :invalid) }

    before do
      sign_in user
    end

    context "パラメータが有効である場合" do
      it "リクエストが成功すること" do
        patch game_path(game), params: { game: game_params }
        expect(response).to have_http_status(302)
      end

      it "データが更新されること" do
        expect do
          patch game_path(game), params: { game: game_params_after_change }
        end.to change { Game.find(game.id).name }.from("テストゲーム").to("変更後ゲーム")
      end

      it "リダイレクトされること" do
        patch game_path(game), params: { game: game_params }
        expect(response).to redirect_to root_path
      end
    end

    context "パラメータが無効である場合" do
      it "リクエストが成功すること" do
        patch game_path(game), params: { game: invalid_game_params }
        expect(response).to have_http_status(200)
      end

      it "データが更新されないこと" do
        expect do
          patch game_path(game), params: { game: invalid_game_params_after_change }
        end.not_to change { Game.find(game.id).name }
      end

      it "エラーが表示されること" do
        patch game_path(game), params: { game: invalid_game_params }
        expect(response.body).to include "更新できませんでした"
      end
    end
  end

  describe "GET #list" do
    let(:another_user) { create(:user) }
    let!(:another_game) { create(:another_game, user: another_user) }

    before do
      sign_in user
      get list_games_path
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(200)
    end

    it "作成した掲示板の情報が表示されること" do
      expect(response.body).to include user.games.first.name
      expect(response.body).to include user.games.first.purpose
      expect(response.body).to include user.games.first.description
    end

    it "他のユーザーが作成した掲示板の情報が表示されないこと" do
      expect(response.body).not_to include another_user.games.first.name
      expect(response.body).not_to include another_user.games.first.purpose
      expect(response.body).not_to include another_user.games.first.description
    end
  end

  describe "GET #search" do
    let!(:another_game) { create(:another_game) }

    before do
      sign_in user
    end

    it "リクエストが成功すること" do
      get search_games_path
      expect(response).to have_http_status(200)
    end

    it "検索ワードがゲーム名に含まれる掲示板の情報が表示されること" do
      search_params = { q: { name_cont: "別の" } }
      get search_games_path, params: search_params
      expect(response.body).to include another_game.name
      expect(response.body).to include another_game.purpose
      expect(response.body).to include another_game.description
    end

    it "検索ワードがゲーム名に含まれない掲示板の情報が表示されないこと" do
      search_params = { q: { name_cont: "別の" } }
      get search_games_path, params: search_params
      expect(response.body).not_to include game.name
    end
  end
end
