require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "名前、メールアドレス、パスワードがあれば有効であること" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "名前、メールアドレス、パスワードがあり、管理者権限がtrueであれば有効であること" do
      admin_user = build(:user, :admin)
      expect(admin_user).to be_valid
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

    it "管理者権限がtrueでもfalseでもなければ無効であること" do
      user = build(:user, admin: "")
      user.valid?
      expect(user.errors[:admin]).to include "is not included in the list"
    end

    it "名前が16文字より多ければ無効であること" do
      user = build(:user, name: "too-long-testname")
      user.valid?
      expect(user.errors[:name]).to include "is too long (maximum is 16 characters)"
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

  describe "メソッド" do
    describe "self.guest" do
      it "ゲストユーザーを作成できること" do
        guest_user = User.guest
        expect(guest_user.email).to eq "guest@example.com"
        expect(guest_user.name).to eq "ゲストユーザー"
        expect(guest_user.password).to eq "guestuser"
      end
    end

    describe "already_liked?(post)" do
      subject { user.already_liked?(post) }

      let(:user) { create(:user) }

      context "ユーザーがチャットにいいねしている場合" do
        let(:post) { create(:post) }
        let!(:like) { create(:like, post: post, user: user) }

        it { is_expected.to eq true }
      end

      context "ユーザーがチャットにいいねしていない場合" do
        let(:post) { create(:post) }

        it { is_expected.to eq false }
      end
    end
  end
end
