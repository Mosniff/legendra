# frozen_string_literal: true

class World < ApplicationRecord
  belongs_to :game
  has_one :story, dependent: :destroy
  has_one :map, dependent: :destroy
  has_many :kingdoms, dependent: :destroy
  has_many :generals, dependent: :destroy

  def select_story(template_name)
    assign_story_from_template(template_name)
    assign_map_from_template(Story.get_map_key_from_story(template_name))
    game.update(game_state: 'in_progress')
  end

  def assign_story_from_template(template_name)
    raise 'Game state must be story_choice to assign a story.' if game.game_state != 'story_choice'

    story = Story.build_from_template(template_name, world: self)
    story.save!
  end

  def assign_map_from_template(template_name)
    raise 'Game state must be story_choice to assign a map.' if game.game_state != 'story_choice'

    map = Map.build_from_template(template_name, world: self)
    map.save!
  end

  def player_kingdom
    kingdoms.find_by(is_player_kingdom: true) || raise('No player kingdom found')
  end
end
