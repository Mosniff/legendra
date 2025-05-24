class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    user_data = UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    games_data = current_user.games.map do |game|
      GameMetadataSerializer.new(game).serializable_hash[:data][:attributes]
    end
    active_game = current_user.games.find_by(active: true)
    render json: { user: user_data, games: games_data, active_game_id: active_game&.id }, status: :ok
  end
end
