class GamesController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to root_path, notice: "新しいページを作成しました"
    else
      flash.now[:alert] = "ページを作成できませんでした"
      render "new"
    end
  end

  def show
    @game = Game.find(params[:id])
    @posts = Post.where(game_id: @game.id)
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
    @games = Game.where(user_id: current_user.id)
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
