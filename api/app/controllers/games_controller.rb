# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    game = current_user.games.build(game_params)
    if game.save
      render json: GameSerializer.new(game, include: %i[world world.map world.map.tiles]).serializable_hash,
             status: :created
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    game = Game.find(params[:id])
    if game.update(game_params)
      render json: GameSerializer.new(game, include: %i[world world.map world.map.tiles]).serializable_hash
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    game = current_user.games.find_by(id: params[:id])
    if game
      render json: GameSerializer.new(game, include: %i[world world.map world.map.tiles]).serializable_hash
    else
      render json: { error: 'Game not found' }, status: :not_found
    end
  end

  def destroy
    game = current_user.games.find_by(id: params[:id])
    if game
      game.destroy
      head :no_content
    else
      render json: { error: 'Game not found' }, status: :not_found
    end
  end

  def scenario_templates
    render json: ScenarioTemplatePresenter.all
  end

  def set_story
    game = current_user.games.find_by(id: params[:id])
    if game
      game.world.select_story(params[:story_key])
    else
      render json: { error: 'Game not found' }, status: :not_found
    end
  end

  private

  def game_params
    params.require(:game).permit(:slot, :id, :active)
  end
end
