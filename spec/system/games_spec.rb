require 'rails_helper'

RSpec.describe "Games", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:game) { create(:game, user: user) }

  describe "トップページ" do
    let!(:games_with_post) { create_list(:game, 6, :with_post) }
    let!(:games_with_genre1) { create_list(:game, 1, genre: "ジャンル1") }
    let!(:games_with_genre2) { create_list(:game, 2, genre: "ジャンル2") }
    let!(:games_with_genre3) { create_list(:game, 3, genre: "ジャンル3") }

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

      it "属しているゲームが多いジャンルが上から3つまで表示されること" do
        expect(page).to have_content "テストジャンル"
        expect(page).to have_content "ジャンル2"
        expect(page).to have_content "ジャンル3"
      end

      it "属しているゲームが多いジャンル上から3つ以外は表示されないこと" do
        expect(page).not_to have_content "ジャンル1"
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

        it "アカウント登録を促す注意書きが表示されること" do
          expect(page).to have_css ".note"
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
          expect(page).to have_content "ユーザー情報の編集"
          expect(page).to have_content "プロフィール"
          expect(page).to have_content "作成した掲示板一覧"
          expect(page).to have_content "ログアウト"
        end

        it "メニューボックス内に「管理画面」が表示されないこと" do
          find(".header-logged-in").click
          expect(page).not_to have_content "管理画面"
        end

        it "ヘッダー内に「ログイン」・「新規登録」が表示されないこと" do
          within "header" do
            expect(page).not_to have_content "ログイン"
            expect(page).not_to have_content "新規登録"
          end
        end

        it "アカウント登録を促す注意書きが表示されないこと" do
          expect(page).not_to have_css ".note"
        end
      end

      context "管理者権限を持ったユーザーでログインしている場合" do
        let(:admin_user) { create(:user, :admin) }

        before do
          sign_in_as(admin_user)
        end

        it "メニューボックス内に「管理画面」が表示されること" do
          find(".header-logged-in").click
          expect(page).to have_content "管理画面"
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

        it "ゲーム名を入力して「検索」をクリックすると、ログインページのテンプレートが表示され、エラーメッセージが表示されること" do
          search_params = { q: { name_cont: "あ" } }
          within ".name-search-form" do
            fill_in "q[name_cont]", with: search_params[:q][:name_cont]
            click_on "検索"
          end
          expect(page).to have_content "You need to sign in or sign up before continuing."
          within ".account-section h1" do
            expect(page).to have_content "ログイン"
          end
        end

        it "ジャンルを入力して「検索」をクリックすると、ログインページのテンプレートが表示され、エラーメッセージが表示されること" do
          search_params = { q: { genre_eq: "あ" } }
          within ".genre-search-form" do
            fill_in "q[genre_eq]", with: search_params[:q][:genre_eq]
            click_on "検索"
          end
          expect(page).to have_content "You need to sign in or sign up before continuing."
          within ".account-section h1" do
            expect(page).to have_content "ログイン"
          end
        end

        it "ゲーム名をクリックすると、ログインページのテンプレートが表示され、エラーメッセージが表示されること" do
          click_on games_with_post.first.name
          expect(page).to have_content "You need to sign in or sign up before continuing."
          within ".account-section h1" do
            expect(page).to have_content "ログイン"
          end
        end

        it "ジャンルをクリックすると、ログインページのテンプレートが表示され、エラーメッセージが表示されること" do
          click_on "テストジャンル"
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

        it "メニューボックス内の「プロフィール」をクリックすると、ユーザープロフィールページに遷移すること" do
          find(".header-logged-in").click
          click_on "プロフィール"
          expect(current_path).to eq user_path(user)
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

        it "ゲーム名を入力して「検索」をクリックすると、掲示板検索結果ページに遷移すること" do
          search_params = { q: { name_cont: "あ" } }
          within ".name-search-form" do
            fill_in "q[name_cont]", with: search_params[:q][:name_cont]
            click_on "検索"
          end
          expect(current_path).to eq search_games_path
        end

        it "ジャンルを入力して「検索」をクリックすると、掲示板検索結果ページに遷移すること" do
          search_params = { q: { genre_eq: "あ" } }
          within ".genre-search-form" do
            fill_in "q[genre_eq]", with: search_params[:q][:genre_eq]
            click_on "検索"
          end
          expect(current_path).to eq search_games_path
        end

        it "ゲーム名をクリックすると、掲示板検索結果ページに遷移すること" do
          click_on games_with_post.first.name
          expect(current_path).to eq search_games_path
        end

        it "ジャンルをクリックすると、掲示板検索結果ページに遷移すること" do
          click_on "テストジャンル"
          expect(current_path).to eq search_games_path
        end

        it "「新しい掲示板を作成」をクリックすると、掲示板作成ページに遷移すること" do
          click_on "新しい掲示板を作成"
          expect(current_path).to eq new_game_path
        end
      end

      context "管理者権限を持ったユーザーでログインしている場合" do
        let(:admin_user) { create(:user, :admin) }

        before do
          sign_in_as(admin_user)
        end

        it "メニューボックス内の「管理画面」をクリックすると、管理画面に遷移すること" do
          find(".header-logged-in").click
          click_on "管理画面"
          expect(current_path).to eq admin_root_path
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
        expect do
          fill_out(game, "new")
          expect(page).to have_content "新しい掲示板を作成しました"
          expect(current_path).to eq root_path
        end.to change { Game.count }.by(1)
      end

      it "入力漏れがある状態で「作成」をクリックすると、登録に失敗し、newテンプレートが表示されること" do
        expect do
          fill_out(invalid_game, "new")
          expect(page).to have_content "掲示板を作成できませんでした"
          within ".game-section h1" do
            expect(page).to have_content "新しい掲示板を作成"
          end
        end.not_to change { Game.count }
      end
    end
  end

  describe "チャットページ" do
    let!(:post) { create(:post, game: game, user: user) }
    let!(:post_with_reply_to) { create(:post, :with_reply_to, chat_num: 2, game: game) }
    let(:another_post) { build(:post, :another, game: game) }
    let!(:like) { create(:like, post: post, user: user) }

    before do
      sign_in_as(user)
      visit game_path(game)
    end

    describe "表示テスト" do
      describe "掲示板の用途の画像" do
        let(:game_trade) { create(:game, purpose: "交換") }
        let(:game_match) { create(:game, purpose: "対戦") }
        let(:game_cooperation) { create(:game, purpose: "マルチプレイ募集") }

        context "掲示板の用途が「交換」の場合" do
          it "「交換」の画像が表示されること" do
            visit game_path(game_trade)
            expect(page).to have_selector "img[src*='trade']"
          end
        end

        context "掲示板の用途が「対戦」の場合" do
          it "「対戦」の画像が表示されること" do
            visit game_path(game_match)
            expect(page).to have_selector "img[src*='match']"
          end
        end

        context "掲示板の用途が「マルチプレイ募集」の場合" do
          it "「マルチプレイ募集」の画像が表示されること" do
            visit game_path(game_cooperation)
            expect(page).to have_selector "img[src*='cooperation']"
          end
        end
      end

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

      it "チャットを入力して「投稿する」をクリックすると、チャットが保存され、投稿したチャットが表示されること" do
        expect do
          fill_in "post[text]", with: another_post.text
          within ".chat-form" do
            click_on "投稿する"
          end
          within "#chat-list-item-3 h3" do
            expect(page).to have_content "3"
            expect(page).to have_content user.name
          end
          expect(page).to have_content another_post.text
          expect(page).to have_content "チャットを投稿しました"
        end.to change { Post.count }.by(1)
      end

      it "チャットを入力せずに「投稿する」をクリックすると、投稿に失敗し、エラーメッセージが表示されること" do
        expect do
          fill_in "post[text]", with: ""
          within ".chat-form" do
            click_on "投稿する"
          end
          within ".chat-list" do
            expect(page).not_to have_content another_post.text
          end
          expect(page).to have_content "投稿できませんでした"
        end.not_to change { Post.count }
      end

      it "検索フォームに値を入力して「検索」をクリックすると、検索条件に該当するチャットのみが表示されること" do
        search_params = {
          q: {
            created_at_gteq: Date.current,
            created_at_lteq_end_of_day: Date.current + 1,
            text_cont: "返信チャット",
          },
        }
        fill_in "q[created_at_gteq]", with: search_params[:q][:created_at_gteq]
        fill_in "q[created_at_lteq_end_of_day]",
          with: search_params[:q][:created_at_lteq_end_of_day]
        fill_in "q[text_cont]", with: search_params[:q][:text_cont]
        click_on "検索"
        expect(page).to have_content post_with_reply_to.text
        expect(page).not_to have_content post.text
      end

      context "自分が投稿したチャットである場合" do
        it "「削除」が表示されること" do
          within "#chat-list-item-1" do
            expect(page).to have_content "削除"
          end
        end

        it "「削除」をクリックすると、確認ダイアログが表示されること" do
          page.dismiss_confirm("チャットを削除します、よろしいですか？") do
            click_on "削除"
          end
        end

        it "「削除」をクリックし、表示された確認ダイアログで「OK」をクリックすると、チャットが削除されること" do
          expect do
            page.accept_confirm("チャットを削除します、よろしいですか？") do
              click_on "削除"
            end
            expect(current_path).to eq game_path(game)
            expect(page).to have_content "チャットを削除しました"
          end.to change { Post.count }.by(-1)
        end
      end

      context "他のユーザーが投稿したチャットである場合" do
        it "「削除」が表示されないこと" do
          within "#chat-list-item-2" do
            expect(page).not_to have_content "削除"
          end
        end
      end

      it "「☆」をクリックすると、「★」に変わり、Likeモデルのレコードが一つ増えること" do
        expect do
          within "#chat-list-item-2 #chat-keep-button-#{post_with_reply_to.chat_num}" do
            find(".like-not-created").click
          end
          within ".like-created" do
            expect(page).to have_content "★"
            expect(page).not_to have_content "☆"
          end
        end.to change { Like.count }.by(1)
      end

      it "「★」をクリックすると、「☆」に変わり、Likeモデルのレコードが一つ減ること" do
        expect do
          within "#chat-list-item-1 #chat-keep-button-#{post.chat_num}" do
            find(".like-created").click
          end
          within ".like-not-created" do
            expect(page).to have_content "☆"
            expect(page).not_to have_content "★"
          end
        end.to change { Like.count }.by(-1)
      end

      it "「返信」をクリックすると、テキストエリア内に「>> + 返信先のチャットの番号」が表示されること" do
        find("#chat-list-item-1 .chat-reply-button").click
        expect(page).to have_field "post[text]", with: ">>1\n"
      end
    end

    describe "ページ遷移テスト" do
      it "チャットを投稿したユーザーの名前をクリックすると、そのユーザーのユーザープロフィールページに遷移すること" do
        within "#chat-list-item-1" do
          click_on post.user.name
        end
        expect(current_path).to eq user_path(post.user)
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
    end

    describe "表示テスト" do
      context "ゲーム名で検索する場合" do
        before do
          visit search_games_path("q[name_cont]": "別の")
        end

        it "検索ワードが表示されること" do
          within ".game-search-word" do
            expect(page).to have_content "別の"
          end
        end

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

      context "ジャンルで検索する場合" do
        before do
          visit search_games_path("q[genre_eq]": "別のジャンル")
        end

        it "検索ワードが表示されること" do
          within ".game-search-word" do
            expect(page).to have_content "別のジャンル"
          end
        end

        it "検索結果の件数が表示されること" do
          within ".game-search-count" do
            expect(page).to have_content "1"
          end
        end

        it "検索ワードのジャンルに属する掲示板の情報が表示されること" do
          expect(page).to have_content another_game.name
          expect(page).to have_content another_game.purpose
          expect(page).to have_content another_game.description
        end

        it "検索ワードのジャンルに属さない掲示板の情報が表示されないこと" do
          expect(page).not_to have_content game.name
        end
      end

      context "検索ワードなしで検索する場合" do
        before do
          visit search_games_path("q[name_cont]": "")
        end

        it "検索結果の件数が表示されること" do
          within ".game-search-count" do
            expect(page).to have_content "2"
          end
        end

        it "全ての掲示板の情報が表示されること" do
          expect(page).to have_content game.name
          expect(page).to have_content game.purpose
          expect(page).to have_content game.description
          expect(page).to have_content another_game.name
          expect(page).to have_content another_game.purpose
          expect(page).to have_content another_game.description
        end
      end
    end

    describe "ページ遷移テスト" do
      before do
        visit search_games_path("q[name_cont]": "別の")
      end

      it "検索結果の枠内をクリックすると、チャットページに遷移すること" do
        find(".game-search-item").click
        expect(current_path).to eq game_path(another_game)
      end
    end
  end
end
