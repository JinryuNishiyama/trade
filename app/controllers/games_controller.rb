class GamesController < ApplicationController
  before_action :exclude_not_logged_in_user, except: :index

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

  private

  def game_params
    params.require(:game).permit(:name, :purpose, :description).merge(user_id: current_user.id)
  end
end
