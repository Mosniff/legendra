# frozen_string_literal: true

class World < ApplicationRecord
  belongs_to :game
  has_one :story, dependent: :destroy
  has_one :map, dependent: :destroy
  has_many :kingdoms, dependent: :destroy
  has_many :generals, dependent: :destroy

  def select_story(template_name)
    raise 'Game state must be story_choice to assign a story.' if game.game_state != 'story_choice'

    WorldGenerationService.new(game: game, story_template_key: template_name).generate_world!
    game.update(game_state: 'in_progress')
  end

  def player_kingdom
    kingdoms.find_by(is_player_kingdom: true) || raise('No player kingdom found')
  end
end
