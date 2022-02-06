class PostsController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @posts = Post.where(game_id: @game.id)
    @post = Post.new(post_params)

    if @post.save
      redirect_to game_path(@game), notice: "チャットを投稿しました"
    else
      redirect_to game_path(@game), alert: "投稿できませんでした"
    end
  end

  private

  def post_params
    params.require(:post).permit(:text).merge(user_id: current_user.id, game_id: @game.id)
  end
end
