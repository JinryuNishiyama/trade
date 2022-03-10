require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "バリデーション" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let!(:like) { create(:like, post: post, user: user) }

    it "user_idとpost_idの組が重複していると無効であること" do
      new_like = build(:like, post: post, user: user)
      new_like.valid?
      expect(new_like.errors[:post_id]).to include "has already been taken"
    end
  end
end
