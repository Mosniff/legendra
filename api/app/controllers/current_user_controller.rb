class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    user_data = UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    games_data = current_user.games.map { |game| GameSerializer.new(game).serializable_hash[:data][:attributes] }
    render json: { user: user_data, games: games_data }, status: :ok
  end
end
