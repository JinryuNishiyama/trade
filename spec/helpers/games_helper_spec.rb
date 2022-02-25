require 'rails_helper'

RSpec.describe GamesHelper, type: :helper do
  describe "generate_link(text, game)" do
    subject { generate_link(text, game) }

    let(:game) { create(:game) }

    context "textに「>> + 数字」が含まれる場合" do
      let(:text) { ">>1テスト" }

      it {
        is_expected.to eq [
          link: (
            link_to ">>1", game_path(game, anchor: "chat-list-item-1"), class: "chat-reply-link"
          ),
          content: "テスト",
        ]
      }
    end

    context "textに「>> + 数字」が含まれない場合" do
      let(:text) { "テスト" }

      it { is_expected.to eq [link: nil, content: "テスト"] }
    end
  end
end
