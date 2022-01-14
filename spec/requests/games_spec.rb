require 'rails_helper'

RSpec.describe "Games", type: :request do
  let!(:game) { create(:game) }

  describe "GET #index" do
    before do
      get root_path
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(200)
    end

    it "レスポンスにゲーム名が含まれること" do
      expect(response.body).to include game.name
    end
  end
end
