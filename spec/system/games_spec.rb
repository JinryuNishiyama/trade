require 'rails_helper'

RSpec.describe "Games", type: :system, js: true do
  let!(:game) { create(:game) }
  let(:user) { create(:user) }
  let(:guest_user) { create(:user, email: "guest@example.com") }

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
            expect(page).not_to have_selector "img[src$='test.jpeg']"
          end
        end
      end

      context "ログインしている場合" do
        before do
          sign_in_as(user)
        end

        it "ヘッダー内に「ログイン」・「新規登録」が表示されないこと" do
          within "header" do
            expect(page).not_to have_content "ログイン"
            expect(page).not_to have_content "新規登録"
          end
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
            configure_icon(user)
          end

          it "ヘッダー内にユーザーの名前とアイコン画像が表示されること" do
            within "header" do
              expect(page).to have_content user.name
              expect(page).to have_selector "img[src$='test.jpeg']"
            end
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

        it "ヘッダー内のユーザー名またはアイコン画像をクリックすると、メニューボックスが表示されること" do
          find(".header-logged-in").click
          expect(page).to have_css ".header-box"
          expect(page).to have_content "ユーザー情報の編集"
          expect(page).to have_content "ログアウト"
        end

        it "メニューボックス内の「ユーザー情報の編集」をクリックすると、ユーザー情報編集ページに遷移すること" do
          find(".header-logged-in").click
          click_on "ユーザー情報の編集"
          expect(current_path).to eq edit_user_registration_path
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
    let(:invalid_game) { build(:game, :invalid) }

    before do
      sign_in_as(user)
      visit new_game_path
    end

    describe "ページ遷移テスト" do
      it "ヘッダー内の「Trade」をクリックすると、トップページに遷移すること" do
        within "header" do
          click_on "Trade"
          expect(current_path).to eq root_path
        end
      end

      it "必要事項を入力して「作成」をクリックすると、登録に成功してトップページに遷移すること" do
        within ".new-game-form" do
          fill_in "ゲーム名", with: game.name
          select "交換", from: "ページの用途"
          fill_in "ページの説明", with: game.description
          click_on "作成"
        end
        expect(page).to have_content "新しいページを作成しました"
        expect(current_path).to eq root_path
      end

      it "入力漏れがある状態で「作成」をクリックすると、登録に失敗し、newテンプレートが表示されること" do
        within ".new-game-form" do
          fill_in "ゲーム名", with: invalid_game.name
          select "交換", from: "ページの用途"
          fill_in "ページの説明", with: invalid_game.description
          click_on "作成"
        end
        expect(page).to have_content "ページを作成できませんでした"
        within ".new-game-section h1" do
          expect(page).to have_content "新しいページを作成"
        end
      end
    end
  end
end
