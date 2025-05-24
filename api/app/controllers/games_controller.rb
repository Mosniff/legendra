# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!

  # TODO: NEXT: user setting game as active/inactive
  # TODO NEXT: user getting game data of active game
  # TODO NEXT: client showing game select screen if no active game
  # TODO NEXT: client showing game screen if active game

  def create
    game = current_user.games.build(game_params)
    if game.save
      render json: game, status: :created
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    game = Game.find(params[:id])
    if game.update(game_params)
      render json: game
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:slot, :id, :active)
  end
end
