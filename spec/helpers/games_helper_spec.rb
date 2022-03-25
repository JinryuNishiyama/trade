require 'rails_helper'

RSpec.describe GamesHelper, type: :helper do
  describe "keyword(*columns)" do
    subject { keyword(*columns) }

    context "params[:q]がnilの場合" do
      let(:columns) { [:column] }
      let(:params) do
        { q: nil }
      end

      it { is_expected.to eq "" }
    end

    context "params[:q]が存在する場合" do
      context "columnsの要素が1つである場合" do
        let(:columns) { [:column] }

        context "params[:q]の要素の値が空白の場合" do
          let(:params) do
            { q: { column: "" } }
          end

          it { is_expected.to eq "" }
        end

        context "params[:q]の要素の値が存在する場合" do
          let(:params) do
            { q: { column: "ゲーム名" } }
          end

          it { is_expected.to eq "ゲーム名" }
        end
      end

      context "columnsの要素が複数ある場合" do
        let(:columns) { [:column1, :column2] }

        context "params[:q]の要素のうち、値がnilのものがある場合" do
          let(:params) do
            { q: { column1: nil, column2: "ジャンル" } }
          end

          it { is_expected.to eq "ジャンル" }
        end

        context "params[:q]の要素のうち、値がnilのものがない場合" do
          let(:params) do
            { q: { column1: "ゲーム名", column2: "ジャンル" } }
          end

          it { is_expected.to eq "ゲーム名,ジャンル" }
        end
      end
    end
  end

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
