require 'rails_helper'

RSpec.describe General, type: :model do
  let(:game) { create(:game, :with_story) }
  let(:general) { create(:general, world: game.world) }
  it 'initializes correctly' do
    expect(general).to be_valid
  end
end
