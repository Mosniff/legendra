# frozen_string_literal: true

class Army < ApplicationRecord
  MAX_GENERALS = 5

  belongs_to :kingdom
  belongs_to :world
  belongs_to :currently_traveling_route, class_name: 'Route', foreign_key: 'route_id', optional: true

  has_many :generals, as: :assignable, after_remove: :destroy_if_empty

  after_update :destroy_if_empty

  def self.spawn_with_generals(army_attrs, generals)
    army = Army.create!(army_attrs)
    generals.each { |general| general.update!(assignable: army) }
    army.reload
    raise ArgumentError, 'Must have at least 1 general' if army.generals.empty?

    army
  end

  def add_generals(generals_to_add)
    unless generals_to_add.is_a?(Enumerable) && generals_to_add.all? { |g| g.is_a?(General) }
      raise ArgumentError, 'generals_to_add must be an collection of General objects'
    end

    if (generals.count + generals_to_add.count) > MAX_GENERALS
      raise ArgumentError,
            "Army already has #{MAX_GENERALS} generals"
    end

    generals_to_add.each do |general|
      raise ArgumentError, 'Cannot add general from a different kingdom' if kingdom && general.kingdom != kingdom

      general.update!(assignable: self)
    end

    save!
  end

  def add_to_garrison(garrison, generals)
    raise ArgumentError, 'Must have at least 1 general' if generals.empty?
    raise ArgumentError, 'All generals must come from this army' unless generals.all? { |g| g.assignable == self }

    unless garrison.x_coord == x_coord && garrison.y_coord == y_coord
      raise ArgumentError,
            'Cannot add to garrison from a different tile'
    end

    garrison.add_generals(generals)
    destroy_if_empty
    garrison
  end

  def remove_general(general)
    raise ArgumentError, 'General is not assigned to this army' unless general.assignable == self

    general.update!(assignable: nil)
    save!
    destroy_if_empty
  end

  def tile
    world.map.tiles.find { |tile| tile.x_coord == x_coord && tile.y_coord == y_coord }
  end

  def coords
    [x_coord, y_coord]
  end

  def player_controlled?
    kingdom&.is_player_kingdom || false
  end

  def destroy_if_empty(_general = nil)
    destroy if generals.empty?
  end

  def current_location
    Location.get_location_at(x_coord, y_coord)
  end

  def assign_to_journey(journey)
    route = journey[:route]
    direction = journey[:direction]
    unless (
      direction == 'forwards' &&
      route.location_a.tile.x_coord == x_coord &&
      route.location_a.tile.y_coord == y_coord
    ) || (
      direction == 'backwards' &&
      route.location_b.tile.x_coord == x_coord &&
      route.location_b.tile.y_coord == y_coord
    )
      raise ArgumentError,
            'Route must start on the same tile as the army'
    end

    update!(currently_traveling_route: route, currently_traveling_route_direction: direction)
  end

  def clear_journey
    update!(currently_traveling_route: nil, currently_traveling_route_direction: nil)
  end

  def advance_along_route(forced_winner: nil, retreating: false)
    unless currently_traveling_route
      raise ArgumentError,
            'Army is not currently traveling along a route'
    end

    if currently_traveling_route_direction == 'forwards'
      move_forwards_along_route(forced_winner: forced_winner, retreating: retreating)
      clear_journey if currently_traveling_route && current_location == currently_traveling_route.location_b

    elsif currently_traveling_route_direction == 'backwards'
      move_backwards_along_route(forced_winner: forced_winner, retreating: retreating)
      clear_journey if currently_traveling_route && current_location == currently_traveling_route.location_a

    else
      raise ArgumentError, 'Invalid route direction'
    end
  end

  def retreat
    if currently_traveling_route &&
       current_location != currently_traveling_route.location_a &&
       current_location != currently_traveling_route.location_b
      retreat_along_route
    else
      retreat_randomly
    end
  end

  private

  def move_to(new_x, new_y)
    raise ArgumentError, 'Can only move to adjacent tiles' if (new_x - x_coord).abs > 1 || (new_y - y_coord).abs > 1

    update!(x_coord: new_x, y_coord: new_y)
  end

  def at_route_start
    currently_traveling_route && current_location == currently_traveling_route.location_a
  end

  def at_route_end
    currently_traveling_route && current_location == currently_traveling_route.location_b
  end

  def move_forwards_along_route(forced_winner: nil, retreating: false)
    if at_route_start
      next_position = currently_traveling_route.path[0]

    elsif x_coord == currently_traveling_route.path[-1][0] && y_coord == currently_traveling_route.path[-1][1]
      destination_tile = currently_traveling_route.location_b.tile
      next_position = [destination_tile.x_coord, destination_tile.y_coord]
    else
      current_path_index = currently_traveling_route.find_path_index_from_coords(x_coord, y_coord)
      next_position = currently_traveling_route.path[current_path_index + 1]
    end

    move_to(next_position[0], next_position[1])
    update!(to_move: false) unless retreating
    check_for_clash(forced_winner: forced_winner)
  end

  def move_backwards_along_route(forced_winner: nil, retreating: false)
    if at_route_end
      next_position = currently_traveling_route.path[-1]

    elsif x_coord == currently_traveling_route.path[0][0] && y_coord == currently_traveling_route.path[0][1]
      destination_tile = currently_traveling_route.location_a.tile
      next_position = [destination_tile.x_coord, destination_tile.y_coord]
    else
      current_path_index = currently_traveling_route.find_path_index_from_coords(x_coord, y_coord)
      next_position = currently_traveling_route.path[current_path_index - 1]
    end

    move_to(next_position[0], next_position[1])
    update!(to_move: false) unless retreating
    check_for_clash(forced_winner: forced_winner)
  end

  def check_for_clash(forced_winner: nil)
    while world.game.game_state != 'awaiting_player' &&
          (opposing_army = world.armies.where.not(kingdom_id: kingdom_id)
                                       .where(x_coord: x_coord, y_coord: y_coord)
                                       .first)
      run_battle(opposing_army, forced_winner: forced_winner)
    end
  end

  def run_battle(opposing_army, forced_winner: nil)
    battle = Battle.create!(
      side_a: kingdom,
      side_b: opposing_army.kingdom,
      tile: tile,
      world: world,
      turn: world.game.turn
    )
    if kingdom.is_player_kingdom || opposing_army.kingdom.is_player_kingdom
      world.game.update(game_state: 'awaiting_player', awaited_event: battle)
    else
      battle.resolve_battle(self, opposing_army, forced_winner: forced_winner)
      # TODO: run battle here, OR set to needs player input if player controlled army involved
    end
  end

  def retreat_along_route
    new_direction = currently_traveling_route_direction == 'forwards' ? 'backwards' : 'forwards'
    update(currently_traveling_route_direction: new_direction)
    advance_along_route(retreating: true)
  end

  def retreat_randomly
    raise 'Cannot retreat randomly when not on a location' unless current_location

    retreating_location = current_location.connected_locations.sample
    assign_to_journey(current_location.get_journey_to(retreating_location))
    advance_along_route
  end
end
