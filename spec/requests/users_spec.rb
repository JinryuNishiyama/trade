require 'rails_helper'

RSpec.describe "Users" do
  describe "POST #guest_sign_in" do
    let(:user) { create(:user) }
    let(:user_params) { attributes_for(:user) }

    it "リクエストが成功すること" do
      post users_guest_sign_in_path, params: { user: user_params }
      expect(response).to have_http_status(302)
    end

    it "データベースへの保存が成功すること" do
      expect do
        post users_guest_sign_in_path, params: { user: user_params }
      end.to change { User.count }.by(1)
    end

    it "リダイレクトされること" do
      post users_guest_sign_in_path, params: { user: user_params }
      expect(response).to redirect_to root_path
    end
  end
end
