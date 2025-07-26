# frozen_string_literal: true

class WorldGenerationService
  def initialize(game:, story_template_key:)
    @game = game
    @world = game.world

    @story_template ||= load_templates('story_templates.yml')[story_template_key]
    @scenario_template ||= load_templates('scenario_templates.yml')[@story_template[:scenario_template_key]]
    @map_template ||= load_templates('map_templates.yml')[@scenario_template[:map_template_key]]
    @general_templates ||= load_templates('general_templates.yml')
  end

  def generate_world!
    # story_attrs = load_story_template
    # scenario = build_and_save_scenario(story_attrs)
    # build_map_from_template(scenario)
    # build_kingdoms_generals_castles(story_attrs, scenario)
    # build_independent_generals(scenario)
    @scenario = build_scenario_from_template!
    @story = build_story_from_template!
    build_kingdoms_and_generals!
    build_independent_generals!
    @map = build_map_from_template!
    build_tiles!
    build_routes!
    @game.update(game_state: 'in_progress')
    @world
  end

  private

  def load_templates(path)
    YAML.load_file(Rails.root.join('lib', 'game_content', path)).deep_symbolize_keys
  rescue Errno::ENOENT
    raise ArgumentError, "Template file not found: #{path}"
  end

  def build_scenario_from_template!
    scenario_attrs = @scenario_template.slice(:title)

    Scenario.create!(scenario_attrs)
  end

  def build_story_from_template!
    story_attrs = @story_template.slice(:title)

    Story.create!(story_attrs.merge(world: @world, scenario: @scenario))
  end

  def build_kingdoms_and_generals!
    kingdoms_data = @scenario_template[:kingdoms] || []
    kingdoms_data.map do |kingdom_attrs|
      # Create kingdom
      is_player_kingdom = kingdom_attrs[:key] == attrs[:player_kingdom_key]
      kingdom = Kingdom.create!(kingdom_attrs.slice(:name).merge(world: world, is_player_kingdom: is_player_kingdom))

      # Create generals for this kingdom
      (kingdom_attrs[:generals] || []).each do |general_ref|
        general_key = general_ref[:key]
        build_general_from_template!(general_key, kingdom: kingdom)
      end
    end
  end

  def build_independent_generals!
    (@scenario_template[:independent_generals] || []).each do |general_ref|
      general_key = general_ref[:key]
      build_general_from_template!(general_key)
    end
  end

  def build_general_from_template!(general_key, kingdom: nil)
    general_attrs = @general_templates[general_key].slice(:name)
    General.create!(general_attrs.merge(world: @world, kingdom: kingdom))
  end

  def build_map_from_template!
    map_attrs = @map_template.slice(:width, :height)
    Map.create!(map_attrs)
  end

  def build_tiles!
    @map.width.times do |x|
      @map.height.times do |y|
        tile_settings = @map_template[:tiles][:rows][x][y]
        tile = @map.tiles.build(x_coord: x, y_coord: y, terrain: tile_settings[:terrain])

        next unless tile_settings[:location]

        build_location!(tile, tile_settings)
      end
    end
  end

  def build_location!(tile, tile_settings)
    # Create either Castle or Town
    locatable_type = tile_settings[:location][:type]
    locatable = locatable_type.classify.constantize.create(name: tile_settings[:location][:name])
    location = Location.create(locatable: locatable)

    tile.location = location
    locatable.location = location
  end

  def build_routes!
    location_lookup = @map.tiles.includes(:location).each_with_object({}) do |tile, lookup|
      next unless tile.location

      locatable = tile.location.locatable
      lookup[locatable.name] = tile.location
    end
    @map_template[:routes]&.each do |route_attrs|
      build_route!(route_attrs, location_lookup)
    end
  end

  def build_route!(route_attrs, location_lookup)
    from_location = location_lookup[route_attrs[:from]]
    to_location = location_lookup[route_attrs[:to]]
    path = route_attrs[:path]

    return unless from_location && to_location

    Route.create!(
      location_a_id: from_location.id,
      location_b_id: to_location.id,
      path: path
    )
  end

  # def load_story_template
  #   story_attrs = Story.templates[@story_template_key]
  #   raise ArgumentError, "Unknown story template: #{@story_template_key}" unless story_attrs

  #   story_attrs
  # end

  # def build_and_save_scenario(story_attrs)
  #   scenario_template_key = Story.get_scenario_template_key(story_attrs)
  #   scenario = Scenario.build_from_template(scenario_template_key)
  #   scenario.save!
  #   scenario
  # end

  # def build_map_from_template(scenario)
  #   scenario_template_key = scenario.class.templates.key(scenario.attributes)
  #   map_template_key = Scenario.templates[scenario_template_key]['map_template_key']
  #   Map.build_from_template(map_template_key, world: @world)
  # end

  # def build_kingdoms_generals_castles(story_attrs, _scenario)
  #   scenario_template_key = Story.get_scenario_template_key(story_attrs)
  #   kingdoms_data = Scenario.templates[scenario_template_key]['kingdoms'] || []
  #   kingdoms_data.each do |kingdom_attrs|
  #     is_player_kingdom = kingdom_attrs['key'] == story_attrs['player_kingdom_key']
  #     kingdom = Kingdom.create!(
  #       kingdom_attrs.except('key', :key, 'generals', :generals, 'castles', :castles).merge(
  #         world: @world,
  #         is_player_kingdom: is_player_kingdom
  #       )
  #     )
  #     (kingdom_attrs['generals'] || []).each do |general_ref|
  #       general_key = general_ref['key'] || general_ref[:key]
  #       General.build_from_template(general_key, world: @world, kingdom: kingdom)
  #     end
  #     (kingdom_attrs['castles'] || []).each do |castle_attrs|
  #       Castle.create!(castle_attrs.merge(kingdom: kingdom))
  #     end
  #   end
  # end

  # def build_independent_generals(scenario)
  #   scenario_template_key = scenario.class.templates.key(scenario.attributes)
  #   (Scenario.templates[scenario_template_key]['independent_generals'] || []).each do |general_ref|
  #     general_key = general_ref['key'] || general_ref[:key]
  #     General.build_from_template(general_key, world: @world, kingdom: nil)
  #   end
  # end

  # world
  # story
  # scenario
  # general
  # castle
  # kingdom
  #
end
