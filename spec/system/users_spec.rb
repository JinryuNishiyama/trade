require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "アカウント登録ページ" do
    let(:user) { build(:user) }

    before do
      visit new_user_registration_path
    end

    describe "ページ遷移テスト" do
      it "必要事項を入力して「登録」をクリックすると、アカウントが登録されてトップページに遷移すること" do
        minimum_password_length = 6
        within ".registration-form" do
          fill_in "名前", with: user.name
          fill_in "メールアドレス", with: user.email
          fill_in "パスワード（#{minimum_password_length}文字以上）", with: user.password
          fill_in "パスワード（確認用）", with: user.password
          click_on "登録"
        end
        expect(current_path).to eq root_path
        expect(page).to have_content "Welcome! You have signed up successfully."
      end

      it "「ログイン」をクリックすると、ログインページに遷移すること" do
        within ".account-section" do
          click_on "ログイン"
        end
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "ログインページ" do
    let!(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    describe "ページ遷移テスト" do
      it "必要事項を入力して「ログイン」をクリックすると、ログインしてトップページに遷移すること" do
        sign_in_as(user)
        expect(current_path).to eq root_path
        expect(page).to have_content "Signed in successfully."
      end

      it "「新規登録」をクリックすると、アカウント登録ページに遷移すること" do
        within ".account-section" do
          click_on "新規登録"
        end
        expect(current_path).to eq new_user_registration_path
      end

      it "「パスワードをお忘れの場合」をクリックすると、パスワード再設定のためのメール送信ページに遷移すること" do
        within ".account-section" do
          click_on "パスワードをお忘れの場合"
        end
        expect(current_path).to eq new_user_password_path
      end

      it "「ゲストユーザーでログイン」をクリックすると、ログインしてトップページに遷移すること" do
        within ".account-section" do
          click_on "ゲストユーザーでログイン"
        end
        expect(current_path).to eq root_path
        expect(page).to have_content "ゲストユーザーとしてログインしました"
      end
    end
  end
end
