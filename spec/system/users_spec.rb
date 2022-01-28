require 'rails_helper'

RSpec.describe "Users", type: :system, js: true do
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
    let(:user) { create(:user) }

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

  describe "ユーザー情報編集ページ" do
    let(:user) { create(:user) }

    describe "表示テスト" do
      context "アイコン画像未登録の場合" do
        before do
          sign_in_as(user)
          visit edit_user_registration_path
        end

        it "アイコン画像を削除するためのチェックボックスが表示されないこと" do
          expect(page).not_to have_content "アイコン画像をデフォルトに戻す"
        end
      end

      context "アイコン画像登録済みの場合" do
        before do
          sign_in_as(user)
          edit(user, "add_icon")
          visit edit_user_registration_path
        end

        it "アイコン画像を削除するためのチェックボックスが表示されること" do
          expect(page).to have_content "アイコン画像をデフォルトに戻す"
        end
      end
    end

    describe "ページ遷移テスト" do
      context "アイコン画像未登録の場合" do
        before do
          sign_in_as(user)
          visit edit_user_registration_path
        end

        it "変更したい項目と現在のパスワードを入力して「更新」をクリックすると、ユーザー情報が更新されてトップページに遷移すること" do
          edit(user, "add_icon")
          expect(current_path).to eq root_path
          expect(page).to have_content "Your account has been updated successfully."
        end

        it "「アカウント削除」をクリックすると、確認ダイアログが表示されること" do
          page.dismiss_confirm("アカウントを削除します、よろしいですか？") do
            within ".delete-account" do
              click_on "アカウント削除"
            end
          end
        end

        it "「アカウント削除」をクリックし、表示された確認ダイアログで「OK」をクリックすると、アカウントが削除されること" do
          expect do
            page.accept_confirm("アカウントを削除します、よろしいですか？") do
              within ".delete-account" do
                click_on "アカウント削除"
              end
            end
            expect(current_path).to eq root_path
            expect(page).to have_content "Your account has been successfully cancelled."
          end.to change { User.count }.by(-1)
        end
      end

      context "アイコン画像登録済みの場合" do
        before do
          sign_in_as(user)
          edit(user, "add_icon")
          visit edit_user_registration_path
        end

        it "「アイコン画像をデフォルトに戻す」にチェックを入れてユーザー情報を更新すると、アイコン画像が削除されること" do
          edit(user, "remove_icon")
          expect(current_path).to eq root_path
          expect(page).to have_content "Your account has been updated successfully."
          expect(user.icon.url).to eq nil
        end
      end
    end
  end
end
