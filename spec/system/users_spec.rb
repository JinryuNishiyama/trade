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
        sign_up_as(user, minimum_password_length)
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
    let(:invalid_user) { build(:user, :invalid) }

    before do
      visit new_user_session_path
    end

    describe "ページ遷移テスト" do
      it "必要事項を入力して「ログイン」をクリックすると、ログインしてトップページに遷移すること" do
        sign_in_as(user)
        expect(current_path).to eq root_path
        expect(page).to have_content "Signed in successfully."
      end

      it "誤ったメールアドレスまたはパスワードを入力して「ログイン」をクリックすると、ログインに失敗し、エラーメッセージが表示されること" do
        sign_in_as(invalid_user)
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content "Invalid Email or password."
      end

      it "「新規登録」をクリックすると、アカウント登録ページに遷移すること" do
        within ".account-section" do
          click_on "新規登録"
        end
        expect(current_path).to eq new_user_registration_path
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
          expect(page).to have_selector "img[src$='test.jpg']"
          expect(page).not_to have_selector "img[src*='default_icon']"
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
          expect(page).to have_selector "img[src*='default_icon']"
          expect(page).not_to have_selector "img[src$='test.jpg']"
        end
      end
    end
  end

  describe "ユーザープロフィールページ" do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:user_with_icon) { create(:user, :with_icon) }
    let!(:user_post) { create(:post, user: user) }
    let!(:liked_post) { create(:post, user: another_user) }
    let!(:like) { create(:like, post: liked_post, user: user) }

    before do
      sign_in_as(user)
    end

    describe "表示テスト" do
      context "アイコン画像未登録の場合" do
        before do
          visit user_path(user)
        end

        it "ユーザーの名前・紹介文・デフォルトのアイコン画像が表示されること" do
          visit user_path(user)
          expect(page).to have_content user.name
          expect(page).to have_content user.introduction
          expect(page).to have_selector "img[src*='default_icon']"
        end

        it "「投稿したチャット一覧を表示」をクリックすると、投稿したチャット一覧が表示されること" do
          find(".show-user-posted-chat-button").click
          expect(page).to have_content "#{user_post.game.name}#{user_post.game.purpose}掲示板"
          expect(page).to have_content user_post.text
          expect(page).to have_content user_post.created_at.to_s(:datetime)
        end

        it "「投稿したチャット一覧を表示」をクリックすると、いいねしたチャット一覧が表示されないこと" do
          find(".show-user-posted-chat-button").click
          expect(find(".show-user-liked-chat", visible: false)).not_to be_visible
        end

        it "「いいねしたチャット一覧を表示」をクリックすると、いいねしたチャット一覧が表示されること" do
          find(".show-user-liked-chat-button").click
          expect(page).to have_content liked_post.user.name
          expect(page).to have_content "#{liked_post.game.name}#{liked_post.game.purpose}掲示板"
          expect(page).to have_content liked_post.text
          expect(page).to have_content liked_post.created_at.to_s(:datetime)
        end

        it "「いいねしたチャット一覧を表示」をクリックすると、投稿したチャット一覧が表示されないこと" do
          find(".show-user-liked-chat-button").click
          expect(find(".show-user-posted-chat", visible: false)).not_to be_visible
        end
      end

      context "アイコン画像登録済みの場合" do
        it "ユーザーの名前・紹介文・アイコン画像が表示されること" do
          visit user_path(user_with_icon)
          expect(page).to have_content user_with_icon.name
          expect(page).to have_content user_with_icon.introduction
          expect(page).to have_selector "img[src$='test.jpg']"
        end
      end
    end

    describe "ページ遷移テスト" do
      before do
        visit user_path(user)
      end

      it "ユーザーのチャットが投稿された掲示板の名前をクリックすると、その掲示板のチャットページに遷移すること" do
        click_on "#{user_post.game.name}#{user_post.game.purpose}掲示板"
        expect(current_path).to eq game_path(user_post.game)
      end

      it "いいねしたチャットを投稿したユーザーの名前をクリックすると、そのユーザーのプロフィールページに遷移すること" do
        find(".show-user-liked-chat-button").click
        click_on liked_post.user.name
        expect(current_path).to eq user_path(liked_post.user)
      end

      it "いいねしたチャットが投稿された掲示板の名前をクリックすると、その掲示板のチャットページに遷移すること" do
        find(".show-user-liked-chat-button").click
        click_on "#{liked_post.game.name}#{liked_post.game.purpose}掲示板"
        expect(current_path).to eq game_path(liked_post.game)
      end
    end
  end
end
