module EditUserModule
  def configure_icon(user)
    visit edit_user_registration_path
    within ".user-edit-form" do
      fill_in "名前", with: user.name
      attach_file "アイコン画像", "#{Rails.root}/spec/factories/test.jpg"
      fill_in "メールアドレス", with: user.email
      fill_in "新しいパスワード", with: ""
      fill_in "新しいパスワード（確認用）", with: ""
      fill_in "現在のパスワード", with: user.password
      click_on "更新"
    end
  end

  def unconfigure_icon(user)
    visit edit_user_registration_path
    within ".user-edit-form" do
      fill_in "名前", with: user.name
      check "アイコン画像をデフォルトに戻す"
      fill_in "メールアドレス", with: user.email
      fill_in "新しいパスワード", with: ""
      fill_in "新しいパスワード（確認用）", with: ""
      fill_in "現在のパスワード", with: user.password
      click_on "更新"
    end
  end
end
