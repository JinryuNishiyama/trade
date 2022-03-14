class PostsController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @posts = @game.posts.includes(:user).order("created_at desc")
    @post = Post.new(post_params)

    if @post.save
      redirect_to game_path(@game), notice: "チャットを投稿しました"
    else
      flash.now[:alert] = "投稿できませんでした"
      render "games/show"
    end
  end

  private

  def post_params
    params.require(:post).permit(:text).merge(
      user_id: current_user.id, game_id: @game.id, chat_num: @posts.count + 1
    )
  end
end
