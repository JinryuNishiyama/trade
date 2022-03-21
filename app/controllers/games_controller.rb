class GamesController < ApplicationController
  MAX_GAMES_COUNT = 5

  before_action :authenticate_user!, except: :index
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @games = Game.joins(:posts).select(:name).group(:name).order("count(text) desc").
      limit(MAX_GAMES_COUNT)
    @q = Game.ransack(params[:q])
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to root_path, notice: "新しい掲示板を作成しました"
    else
      flash.now[:alert] = "掲示板を作成できませんでした"
      render "new"
    end
  end

  def show
    @game = Game.find(params[:id])
    @q = @game.posts.ransack(params[:q])
    @posts = @q.result.includes(:user).order("created_at desc")
    @post = Post.new
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(game_params)
      redirect_to root_path, notice: "掲示板の情報を更新しました"
    else
      flash.now[:alert] = "更新できませんでした"
      render "edit"
    end
  end

  def list
    @games = current_user.games
  end

  def search
    @q = Game.ransack(params[:q])
    @games = @q.result(distinct: true)
  end

  private

  def game_params
    params.require(:game).permit(:name, :purpose, :description).merge(user_id: current_user.id)
  end

  def ensure_correct_user
    @game = Game.find(params[:id])
    if @game.user_id != current_user.id
      redirect_to root_path, alert: "他のユーザーが作成した掲示板の情報は編集できません"
    end
  end
end
