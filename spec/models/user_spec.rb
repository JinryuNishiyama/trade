require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "名前、メールアドレス、パスワードがあれば有効であること" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "名前がなければ無効であること" do
      user = build(:user, name: "")
      user.valid?
      expect(user.errors[:name]).to include "can't be blank"
    end

    it "メールアドレスがなければ無効であること" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include "can't be blank"
    end

    it "パスワードがなければ無効であること" do
      user = build(:user, password: "")
      user.valid?
      expect(user.errors[:password]).to include "can't be blank"
    end

    it "パスワードが設定した文字数以下であれば無効であること" do
      minimum_password_length = 6
      user = build(:user, password: "test")
      user.valid?
      expect(user.errors[:password]).
        to include "is too short (minimum is #{minimum_password_length} characters)"
    end

    it "メールアドレスが重複していると無効であること" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include "has already been taken"
    end
  end
end
