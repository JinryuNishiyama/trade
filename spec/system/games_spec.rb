require 'rails_helper'

RSpec.describe "Games", type: :system do
  let!(:game) { create(:game) }

  describe "トップページ" do
    before do
      visit root_path
    end

    describe "表示テスト" do
      it "ゲーム名が表示されること" do
        expect(page).to have_content game.name
      end
    end
  end
end
