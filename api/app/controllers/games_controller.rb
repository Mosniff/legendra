# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    game = current_user.games.build(game_params)
    if game.save
      render json: GameSerializer.new(game,
                                      include: %i[world.map world.map.tiles world.kingdoms
                                                  world.generals world.armies world.castles world.towns]).serializable_hash
      status :created
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    game = Game.find(params[:id])
    if game.update(game_params)
      render json: GameSerializer.new(game,
                                      include: %i[world.map world.map.tiles world.kingdoms
                                                  world.generals world.armies world.castles world.towns]).serializable_hash
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    game = current_user.games.find_by(id: params[:id])
    if game
      render json: GameSerializer.new(game, include: %i[world.map world.map.tiles world.kingdoms
                                                        world.generals world.armies world.castles world.towns]).serializable_hash
    else
      render json: { error: 'Game not found' }, status: :not_found
    end
  end

  def destroy
    game = current_user.games.find_by(id: params[:id])
    if game
      begin
        game.destroy!
      rescue StandardError => e
        puts "Destroy failed: #{e.class} - #{e.message}"
        puts e.backtrace
      end
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

  def create_army_from_garrison
    game = current_user.games.find_by(id: params[:id])
    if game
      generals = game.world.generals.where(id: params[:selected_general_ids])
      game.world.castles.find(params[:castle_id]).garrison.create_army(generals)
    else
      render json: { error: 'Game not found' }, status: :not_found
    end
  end

  def add_to_garrison_from_army
    game = current_user.games.find_by(id: params[:id])
    if game
      army = game.world.armies.find(params[:army_id])
      garrison = game.world.map.tiles.find_by(x_coord: army.x_coord, y_coord: army.y_coord).castle.garrison
      generals = game.world.generals.where(id: params[:selected_general_ids])
      army.add_to_garrison(garrison, generals)
    else
      render json: { error: 'Game not found' }, status: :not_found
    end
  end

  def add_to_army_from_garrison
    game = current_user.games.find_by(id: params[:id])
    if game
      army = game.world.armies.find(params[:army_id])
      garrison = game.world.castles.find(params[:castle_id]).garrison
      generals = game.world.generals.where(id: params[:selected_general_ids])
      garrison.add_to_army(army, generals)
    else
      render json: { error: 'Game not found' }, status: :not_found
    end
  end

  def advance_turn
    game = current_user.games.find_by(id: params[:id])
    return unless game

    game.attempt_advance_turn
  end

  private

  def game_params
    params.require(:game).permit(:slot, :id, :active)
  end
end
