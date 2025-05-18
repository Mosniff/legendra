require 'rails_helper'

RSpec.describe Game, type: :model do
  it 'should initialize correctly' do
    game = create(:game)
    expect(game).to be_valid
    expect(game.user).to be_a(User)
  end
end
