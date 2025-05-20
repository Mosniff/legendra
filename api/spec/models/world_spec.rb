# frozen_string_literal: true

require 'rails_helper'

RSpec.describe World, type: :model do
  it 'should initialize correctly' do
    world = create(:game).world
    expect(world).to be_valid
    expect(world.game).to be_a(Game)
  end
end
