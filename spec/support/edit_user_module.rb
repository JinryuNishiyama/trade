module EditUserModule
  def edit(user, icon_setting)
    visit edit_user_registration_path
    within ".user-edit-form" do
      fill_in "名前", with: user.name
      if icon_setting == "add_icon"
        attach_file "アイコン画像", "#{Rails.root}/spec/factories/test.jpg"
      else
        check "アイコン画像をデフォルトに戻す"
      end
      fill_in "自己紹介", with: user.introduction
      fill_in "メールアドレス", with: user.email
      fill_in "新しいパスワード", with: ""
      fill_in "新しいパスワード（確認用）", with: ""
      fill_in "現在のパスワード", with: user.password
      click_on "更新"
    end
  end
end
