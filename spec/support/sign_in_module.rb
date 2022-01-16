module SignInModule
  def sign_in_as(user)
    visit new_user_session_path
    within ".session-form" do
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_on "ログイン"
    end
  end
end
