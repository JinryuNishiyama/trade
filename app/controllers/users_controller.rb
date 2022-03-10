class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.includes(:game).order("created_at desc")
    @all_posts = Post.includes([:game, :user])
  end
end
