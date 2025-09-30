# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :user

  validates :slot, presence: true, inclusion: { in: 0..9 }
  validates :slot, uniqueness: { scope: :user_id }

  GAME_STATES = %w[story_choice orders_phase resolving_movement awaiting_player].freeze
  validates :game_state, inclusion: { in: GAME_STATES }

  has_one :world, dependent: :destroy
  has_one :story, through: :world
  has_one :awaited_event, class_name: 'Battle', foreign_key: 'game_id', dependent: :nullify

  after_create :create_world
  before_save :ensure_single_active_game

  before_create :set_starting_turn

  def attempt_advance_turn
    if game_state == 'orders_phase'
      world.set_armies_to_move
      update(game_state: 'resolving_movement')
    end

    world.armies_to_move.first.advance_along_route while game_state == 'resolving_movement' && world.armies_to_move.any?

    advance_turn if game_state == 'resolving_movement' && world.armies_to_move.empty?
  end

  def player_resume_turn
    raise 'Game state must be awaiting_player to resume turn.' if game_state != 'awaiting_player'

    # update(game_state: 'resolving_movement')
    # world.armies_to_move.first.advance_along_route while game_state == 'resolving_movement' && world.armies_to_move.any?
    # advance_turn if game_state == 'resolving_movement' && world.armies_to_move.empty?
  end

  private

  def advance_turn
    self.game_state = 'orders_phase'
    self.turn += 1
    save
  end

  def set_starting_turn
    self.turn ||= 1
  end

  def create_world
    World.create!(game: self)
  end

  def ensure_single_active_game
    return unless active_changed? && active?

    user.games.where.not(id: id).where(active: true).update_all(active: false)
  end
end
