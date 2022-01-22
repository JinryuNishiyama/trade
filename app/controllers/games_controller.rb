class GamesController < ApplicationController
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

  private

  def game_params
    params.require(:game).permit(:name, :purpose, :description)
  end
end
