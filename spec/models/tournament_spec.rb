require 'rails_helper'

RSpec.describe Tournament, type: :model do
  before(:each) do
    @tournament = Tournament.new
  end
  context "with 3 people" do
    before(:each) do
      players = [ Player.new(name: "A"), Player.new(name: "B"), Player.new(name: "C") ]
      @tournament.players = players
      @tournament.generate_rounds
    end

    it "has a single round" do
      expect(@tournament.rounds.length).to eq(1)
    end

    it "gives each player the same round" do
      round = @tournament.rounds.first
      expect(round.players).to eq(@tournament.players)
    end
  end
end
