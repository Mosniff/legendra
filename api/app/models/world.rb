# frozen_string_literal: true

class World < ApplicationRecord
  belongs_to :game
  has_one :story, dependent: :destroy

  def assign_story_from_template(template_name)
    story = Story.build_from_template(template_name, world: self)
    story.save!
  end
end
