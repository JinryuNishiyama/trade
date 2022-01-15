require 'rails_helper'

RSpec.describe "Games", type: :system do
  let!(:game) { create(:game) }

  describe "トップページ" do
    before do
      visit root_path
    end

    describe "表示テスト" do
      it "ゲーム名が表示されること" do
        expect(page).to have_content game.name
      end

      it "ヘッダー内に「ログイン」・「新規登録」が表示され、「ログアウト」が表示されないこと" do
        within "header" do
          expect(page).to have_content "ログイン"
          expect(page).to have_content "新規登録"
          expect(page).not_to have_content "ログアウト"
        end
      end
    end

    describe "ページ遷移テスト" do
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
    end
  end
end
