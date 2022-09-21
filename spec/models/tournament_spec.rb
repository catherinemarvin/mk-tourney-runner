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

  context "with 4 people" do
    before(:each) do
      players = [ Player.new(name: "A"), Player.new(name: "B"), Player.new(name: "C") ]
      @tournament.players = players
      @tournament.generate_rounds
      @tournament.save
    end

    it "has a single round" do
      expect(@tournament.rounds.length).to eq(1)
    end

    it "gives each player the same round" do
      round = @tournament.rounds.first
      expect(round.players).to eq(@tournament.players)
    end
  end

  context "with 8 people" do
    before(:each) do
      players = [ Player.new(name: "A"), 
        Player.new(name:"B"),
        Player.new(name:"C"),
        Player.new(name:"D"),
        Player.new(name:"E"),
        Player.new(name:"F"),
        Player.new(name:"G"),
        Player.new(name:"H"),
      ]
      @tournament.players = players
      @tournament.generate_rounds
      @tournament.save
    end

    it "has three rounds" do
      expect(@tournament.rounds.length).to eq(3)
    end

    it "has two starting rounds with non-overlapping players" do
      starting_rounds = @tournament.rounds.filter do |round|
        round.previous_rounds.length == 0
      end
      players = starting_rounds.flatten.flat_map { |round| round.players }

      expect(starting_rounds.length).to eq(2)
      expect(players.uniq!).to be_nil
    end
  end
end
