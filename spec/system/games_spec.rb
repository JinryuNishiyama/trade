require 'rails_helper'

RSpec.describe "Games", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:game) { create(:game, user: user) }

  describe "トップページ" do
    before do
      visit root_path
    end

    describe "表示テスト" do
      it "ゲーム名が表示されること" do
        expect(page).to have_content game.name
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

        it "「新しいページを作成」をクリックすると、ログインページに遷移し、エラーメッセージが表示されること" do
          click_on "新しいページを作成"
          expect(page).to have_content "ログインしてください"
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

        it "メニューボックス内の「作成した掲示板一覧」をクリックすると、掲示板一覧ページに遷移すること" do
          find(".header-logged-in").click
          click_on "作成した掲示板一覧"
          expect(current_path).to eq games_list_path
        end

        it "メニューボックス内の「ログアウト」をクリックすると、ログアウトしてメッセージが表示されること" do
          find(".header-logged-in").click
          click_on "ログアウト"
          expect(current_path).to eq root_path
          expect(page).to have_content "Signed out successfully."
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

        it "「新しいページを作成」をクリックすると、掲示板作成ページに遷移すること" do
          click_on "新しいページを作成"
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
        expect(page).to have_content "新しいページを作成しました"
        expect(current_path).to eq root_path
      end

      it "入力漏れがある状態で「作成」をクリックすると、登録に失敗し、newテンプレートが表示されること" do
        fill_out(invalid_game, "new")
        expect(page).to have_content "ページを作成できませんでした"
        within ".game-section h1" do
          expect(page).to have_content "新しいページを作成"
        end
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
      visit games_list_path
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
end
