# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    game = current_user.games.build(game_params)
    if game.save
      render json: game, status: :created
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:slot)
  end
end
