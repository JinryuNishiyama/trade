module SignUpModule
  def sign_up_as(user, minimum_password_length)
    within ".registration-form" do
      fill_in "名前", with: user.name
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード（#{minimum_password_length}文字以上）", with: user.password
      fill_in "パスワード（確認用）", with: user.password
      click_on "登録"
    end
  end
end
