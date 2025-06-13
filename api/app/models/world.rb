# frozen_string_literal: true

class World < ApplicationRecord
  belongs_to :game
  has_one :story, dependent: :destroy

  def assign_story_from_template(template_name)
    raise 'Game state must be story_choice to assign a story.' if game.game_state != 'story_choice'

    story = Story.build_from_template(template_name, world: self)
    story.save!
    game.update(game_state: 'world_gen')
  end
end
