require 'rails_helper'

RSpec.describe "Games", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:game) { create(:game, user: user) }

  describe "トップページ" do
    let!(:games_with_post) { create_list(:game, 6, :with_post) }

    before do
      visit root_path
    end

    describe "表示テスト" do
      it "掲示板のゲーム名が表示されること" do
        expect(page).to have_content games_with_post.first.name
      end

      it "チャットが一件もない掲示板のゲーム名が表示されないこと" do
        expect(page).not_to have_content game.name
      end

      it "6件目以降の掲示板のゲーム名が表示されないこと" do
        expect(page).not_to have_content games_with_post.last.name
      end

      context "ログインしていない場合" do
        it "ヘッダー内に「ログイン」・「新規登録」が表示されること" do
          within "header" do
            expect(page).to have_content "ログイン"
            expect(page).to have_content "新規登録"
          end
        end

        it "ヘッダー内にユーザーの名前とアイコン画像が表示されないこと" do
          within "header" do
            expect(page).not_to have_content user.name
            expect(page).not_to have_selector "img[src$='test.jpg']"
          end
        end
      end

      context "ログインしている場合" do
        before do
          sign_in_as(user)
        end

        context "アイコン画像未登録の場合" do
          it "ヘッダー内にユーザーの名前とデフォルトのアイコン画像が表示されること" do
            within "header" do
              expect(page).to have_content user.name
              expect(page).to have_selector "img[src*='default_icon']"
            end
          end
        end

        context "アイコン画像登録済みの場合" do
          before do
            edit(user, "add_icon")
          end

          it "ヘッダー内にユーザーの名前とアイコン画像が表示されること" do
            within "header" do
              expect(page).to have_content user.name
              expect(page).to have_selector "img[src$='test.jpg']"
            end
          end
        end

        it "ヘッダー内のユーザー名またはアイコン画像をクリックすると、メニューボックスが表示されること" do
          find(".header-logged-in").click
          expect(page).to have_css ".header-box"
          expect(page).to have_content "ユーザー情報の編集"
          expect(page).to have_content "作成した掲示板一覧"
          expect(page).to have_content "ログアウト"
        end

        it "ヘッダー内に「ログイン」・「新規登録」が表示されないこと" do
          within "header" do
            expect(page).not_to have_content "ログイン"
            expect(page).not_to have_content "新規登録"
          end
        end
      end
    end

    describe "ページ遷移テスト" do
      context "ログインしていない場合" do
        it "ヘッダー内の「ログイン」をクリックすると、ログインページに遷移すること" do
          within "header" do
            click_on "ログイン"
          end
          expect(current_path).to eq new_user_session_path
        end

        it "ヘッダー内の「新規登録」をクリックすると、アカウント登録ページに遷移すること" do
          within "header" do
            click_on "新規登録"
          end
          expect(current_path).to eq new_user_registration_path
        end

        it "検索ワードを入力して「検索」をクリックすると、ログインページのテンプレートが表示され、エラーメッセージが表示されること" do
          search_params = { q: { name_cont: "あ" } }
          within ".search-form" do
            fill_in "q[name_cont]", with: search_params[:q][:name_cont]
            click_on "検索"
          end
          expect(page).to have_content "You need to sign in or sign up before continuing."
          within ".account-section h1" do
            expect(page).to have_content "ログイン"
          end
        end

        it "「アカウント登録はこちらから」の「こちら」をクリックすると、アカウント登録ページに遷移すること" do
          within ".note-registration" do
            click_on "こちら"
          end
          expect(current_path).to eq new_user_registration_path
        end

        it "「ログインはこちらから」の「こちら」をクリックすると、ログインページに遷移すること" do
          within ".note-login" do
            click_on "こちら"
          end
          expect(current_path).to eq new_user_session_path
        end

        it "ゲーム名をクリックすると、ログインページのテンプレートが表示され、エラーメッセージが表示されること" do
          click_on games_with_post.first.name
          expect(page).to have_content "You need to sign in or sign up before continuing."
          within ".account-section h1" do
            expect(page).to have_content "ログイン"
          end
        end

        it "「新しい掲示板を作成」をクリックすると、ログインページのテンプレートが表示され、エラーメッセージが表示されること" do
          click_on "新しい掲示板を作成"
          expect(page).to have_content "You need to sign in or sign up before continuing."
          within ".account-section h1" do
            expect(page).to have_content "ログイン"
          end
        end
      end

      context "ログインしている場合" do
        before do
          sign_in_as(user)
        end

        it "メニューボックス内の「ユーザー情報の編集」をクリックすると、ユーザー情報編集ページに遷移すること" do
          find(".header-logged-in").click
          click_on "ユーザー情報の編集"
          expect(current_path).to eq edit_user_registration_path
        end

        it "メニューボックス内の「作成した掲示板一覧」をクリックすると、掲示板一覧ページに遷移すること" do
          find(".header-logged-in").click
          click_on "作成した掲示板一覧"
          expect(current_path).to eq list_games_path
        end

        it "メニューボックス内の「ログアウト」をクリックすると、ログアウトしてメッセージが表示されること" do
          find(".header-logged-in").click
          click_on "ログアウト"
          expect(current_path).to eq root_path
          expect(page).to have_content "Signed out successfully."
        end

        it "検索ワードを入力して「検索」をクリックすると、掲示板検索結果ページに遷移すること" do
          search_params = { q: { name_cont: "あ" } }
          within ".search-form" do
            fill_in "q[name_cont]", with: search_params[:q][:name_cont]
            click_on "検索"
          end
          expect(current_path).to eq search_games_path
        end

        it "「アカウント登録はこちらから」の「こちら」をクリックすると、アカウント登録ページに遷移せず、エラーメッセージが表示されること" do
          within ".note-registration" do
            click_on "こちら"
          end
          expect(page).to have_content "You are already signed in."
          expect(current_path).to eq root_path
        end

        it "「ログインはこちらから」の「こちら」をクリックすると、ログインページに遷移せず、エラーメッセージが表示されること" do
          within ".note-login" do
            click_on "こちら"
          end
          expect(page).to have_content "You are already signed in."
          expect(current_path).to eq root_path
        end

        it "ゲーム名をクリックすると、掲示板検索結果ページに遷移すること" do
          click_on games_with_post.first.name
          expect(current_path).to eq search_games_path
        end

        it "「新しい掲示板を作成」をクリックすると、掲示板作成ページに遷移すること" do
          click_on "新しい掲示板を作成"
          expect(current_path).to eq new_game_path
        end
      end

      context "ゲストユーザーでログインしている場合" do
        let(:guest_user) { create(:user, :guest) }

        before do
          sign_in_as(guest_user)
        end

        it "メニューボックス内の「ユーザー情報の編集」をクリックすると、ユーザー情報編集ページに遷移せず、エラーメッセージが表示されること" do
          find(".header-logged-in").click
          click_on "ユーザー情報の編集"
          expect(page).to have_content "ゲストユーザーの情報は変更できません"
          expect(current_path).to eq root_path
        end
      end
    end
  end

  describe "掲示板作成ページ" do
    let(:invalid_game) { build(:game, :invalid, user: user) }

    before do
      sign_in_as(user)
      visit new_game_path
    end

    describe "表示テスト" do
      it "データを送信するボタン内に「作成」と表示されること" do
        expect(page).to have_button "作成"
      end
    end

    describe "ページ遷移テスト" do
      it "ヘッダー内の「Trade」をクリックすると、トップページに遷移すること" do
        within "header" do
          click_on "Trade"
          expect(current_path).to eq root_path
        end
      end

      it "必要事項を入力して「作成」をクリックすると、登録に成功してトップページに遷移すること" do
        fill_out(game, "new")
        expect(page).to have_content "新しい掲示板を作成しました"
        expect(current_path).to eq root_path
      end

      it "入力漏れがある状態で「作成」をクリックすると、登録に失敗し、newテンプレートが表示されること" do
        fill_out(invalid_game, "new")
        expect(page).to have_content "掲示板を作成できませんでした"
        within ".game-section h1" do
          expect(page).to have_content "新しい掲示板を作成"
        end
      end
    end
  end

  describe "チャットページ" do
    let!(:post) { create(:post, game: game) }
    let!(:post_with_reply_to) { create(:post, :with_reply_to, game: game) }
    let(:another_post) { build(:post, :another, game: game) }

    before do
      sign_in_as(user)
      visit game_path(game)
    end

    describe "表示テスト" do
      it "ゲーム名と掲示板の用途が表示されること" do
        within ".chat-section h1" do
          expect(page).to have_content game.name
          expect(page).to have_content game.purpose
        end
      end

      it "掲示板の説明が表示されること" do
        within ".chat-section" do
          expect(page).to have_content game.description
        end
      end

      it "チャットを投稿したユーザーの名前が表示されること" do
        within ".chat-list" do
          expect(page).to have_content post.user.name
        end
      end

      it "チャットの内容が表示されること" do
        within ".chat-list" do
          expect(page).to have_content post.text
        end
      end

      it "チャットの作成日時が表示されること" do
        within ".chat-list" do
          expect(page).to have_content post.created_at.to_s(:datetime)
        end
      end

      it "チャットを入力して「投稿する」をクリックすると、投稿したチャットが表示されること" do
        fill_in "post[text]", with: another_post.text
        within ".chat-form" do
          click_on "投稿する"
        end
        within ".chat-list" do
          expect(page).to have_content user.name
          expect(page).to have_content another_post.text
        end
        expect(page).to have_content "チャットを投稿しました"
      end

      it "チャットを入力せずに「投稿する」をクリックすると、投稿に失敗し、エラーメッセージが表示されること" do
        fill_in "post[text]", with: ""
        within ".chat-form" do
          click_on "投稿する"
        end
        within ".chat-list" do
          expect(page).not_to have_content another_post.text
        end
        expect(page).to have_content "投稿できませんでした"
      end

      it "「返信」をクリックすると、テキストエリア内に「>> + 返信先のチャットの番号」が表示されること" do
        find("#chat-list-item-1 .chat-reply-button").click
        expect(page).to have_field "post[text]", with: ">>1\n"
      end

      it "「>> + 返信先のチャットの番号」をクリックすると、返信先のチャットまでページ内ジャンプすること" do
        within "#chat-list-item-2" do
          click_on ">>1"
        end
        expect(current_path).to eq game_path(game)
      end
    end
  end

  describe "掲示板情報編集ページ" do
    let(:invalid_game) { build(:game, :invalid, user: user) }
    let(:another_game) { create(:another_game) }

    before do
      sign_in_as(user)
      visit edit_game_path(game)
    end

    describe "表示テスト" do
      it "データを送信するボタン内に「更新」と表示されること" do
        expect(page).to have_button "更新"
      end
    end

    describe "ページ遷移テスト" do
      it "必要事項を入力して「更新」をクリックすると、データの更新に成功し、トップページに遷移すること" do
        fill_out(game, "edit")
        expect(page).to have_content "掲示板の情報を更新しました"
        expect(current_path).to eq root_path
      end

      it "入力漏れがある状態で「更新」をクリックすると、データの更新に失敗し、editテンプレートが表示されること" do
        fill_out(invalid_game, "edit")
        expect(page).to have_content "更新できませんでした"
        within ".game-section h1" do
          expect(page).to have_content "掲示板の情報を編集"
        end
      end

      it "ある掲示板の作成者ではないユーザーがその掲示板の情報編集ページに遷移しようとすると、遷移せず、エラーメッセージが出力されること" do
        visit edit_game_path(another_game)
        expect(page).to have_content "他のユーザーが作成した掲示板の情報は編集できません"
        expect(current_path).to eq root_path
      end
    end
  end

  describe "掲示板一覧ページ" do
    let(:another_user) { create(:user) }
    let!(:another_game) { create(:another_game, user: another_user) }

    before do
      sign_in_as(user)
      visit list_games_path
    end

    describe "表示テスト" do
      it "作成した掲示板の数の合計が表示されること" do
        within ".game-list-section h3" do
          expect(page).to have_content user.games.count
        end
      end

      it "作成した掲示板の情報が表示されること" do
        expect(page).to have_content user.games.first.name
        expect(page).to have_content user.games.first.purpose
        expect(page).to have_content user.games.first.description
      end

      it "他のユーザーが作成した掲示板の情報が表示されないこと" do
        expect(page).not_to have_content another_user.games.first.name
        expect(page).not_to have_content another_user.games.first.purpose
        expect(page).not_to have_content another_user.games.first.description
      end
    end

    describe "ページ遷移テスト" do
      it "「編集」をクリックすると、掲示板情報編集ページに遷移すること" do
        within ".game-list-section" do
          click_on "編集"
        end
        expect(current_path).to eq edit_game_path(game)
      end
    end
  end

  describe "掲示板検索結果ページ" do
    let!(:another_game) { create(:another_game) }

    before do
      sign_in_as(user)
      visit search_games_path("q[name_cont]": "別の")
    end

    describe "表示テスト" do
      it "検索結果の件数が表示されること" do
        within ".game-search-count" do
          expect(page).to have_content "1"
        end
      end

      it "検索ワードがゲーム名に含まれる掲示板の情報が表示されること" do
        expect(page).to have_content another_game.name
        expect(page).to have_content another_game.purpose
        expect(page).to have_content another_game.description
      end

      it "検索ワードがゲーム名に含まれない掲示板の情報が表示されないこと" do
        expect(page).not_to have_content game.name
      end
    end

    describe "ページ遷移テスト" do
      it "検索結果の枠内をクリックすると、チャットページに遷移すること" do
        find(".game-search-item").click
        expect(current_path).to eq game_path(another_game)
      end
    end
  end
end
