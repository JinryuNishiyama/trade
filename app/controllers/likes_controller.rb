class LikesController < ApplicationController
  before_action :set_params

  def create
    @like = Like.create(user_id: current_user.id, post_id: @post.id)
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, post_id: @post.id)
    @like.destroy
  end

  private

  def set_params
    @game = Game.find(params[:game_id])
    @post = Post.find(params[:post_id])
  end
end
