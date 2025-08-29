# frozen_string_literal: true

class WorldGenerationService
  def initialize(game:, story_template_key:)
    @game = game
    @world = game.world
    @story_template_key = story_template_key.to_sym

    @story_template = TemplateLoader.load_templates('story_templates.yml')[@story_template_key]
    @scenario_template = TemplateLoader.load_templates('scenario_templates.yml')[@story_template[:scenario_template_key].to_sym]
    @map_template = TemplateLoader.load_templates('map_templates.yml')[@scenario_template[:map_template_key].to_sym]
    @general_templates = TemplateLoader.load_templates('general_templates.yml')
  end

  def generate_world!
    @scenario = build_scenario_from_template!
    @story = build_story_from_template!
    @map = build_map_from_template!
    build_tiles!
    build_routes!
    build_kingdoms_and_generals!
    build_independent_generals!
    @world
  end

  private

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
      is_player_kingdom = kingdom_attrs[:key] == @story_template[:player_kingdom_key]
      kingdom = Kingdom.create!(kingdom_attrs.slice(:name).merge(world: @world, is_player_kingdom: is_player_kingdom))

      # Create generals for this kingdom
      (kingdom_attrs[:generals] || []).each do |general_ref|
        general_key = general_ref[:key].to_sym
        general = build_general_from_template!(general_key, kingdom: kingdom)
        next unless general_ref[:starting_castle]

        castle_name = general_ref[:starting_castle]
        @map.castles.find_by(name: castle_name).garrison.add_generals([general])
      end
    end
  end

  def build_independent_generals!
    (@scenario_template[:independent_generals] || []).each do |general_ref|
      general_key = general_ref[:key].to_sym
      build_general_from_template!(general_key)
    end
  end

  def build_general_from_template!(general_key, kingdom: nil)
    general_attrs = @general_templates[general_key].slice(:name)
    General.create!(general_attrs.merge(world: @world, kingdom: kingdom))
  end

  def build_map_from_template!
    map_attrs = @map_template.slice(:width, :height)
    Map.create!(map_attrs.merge(world: @world))
  end

  def build_tiles!
    @map.width.times do |x|
      @map.height.times do |y|
        tile_settings = @map_template[:tiles][:rows][x][y]
        tile = @map.tiles.create!(x_coord: x, y_coord: y, terrain: tile_settings[:terrain])

        next unless tile_settings[:location]

        build_location!(tile, tile_settings)
      end
    end
  end

  def build_location!(tile, tile_settings)
    locatable_type = tile_settings[:location][:type]
    # Create the Location first, then the locatable with the location set
    location = Location.new(tile: tile)
    locatable = locatable_type.classify.constantize.new(name: tile_settings[:location][:name], location: location)
    location.locatable = locatable
    location.save!
    locatable.save!

    tile.update!(location: location)
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
end
