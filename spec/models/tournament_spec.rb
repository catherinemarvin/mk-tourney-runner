require 'rails_helper'

RSpec.describe Tournament, type: :model do

  # Generates n number of players
  def generate_players(n)
    (1..n).each do |x|
      @tournament.players.build(name: x.to_s)
    end
  end

  before(:each) do
    @tournament = Tournament.new
  end

  context "with 3 people" do
    before(:each) do
      generate_players(3)
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
      generate_players(4)
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

  context "with 6 people" do
    before(:each) do
      generate_players(6)
      @tournament.generate_rounds
      @tournament.save
    end

    it "has three rounds" do
      expect(@tournament.rounds.length).to eq(3)
    end

    it "has a first round with 4 players and two next rounds" do
      rounds = @tournament.rounds.filter do |round|
        round.previous_rounds.empty?
      end

      expect(rounds.length).to eq(1)
      round = rounds[0]
      expect(round.players.length).to eq(4)
      expect(round.next_rounds.length).to eq(2)
    end

    it "has a final round with two previous rounds" do
      rounds = @tournament.rounds.filter do |round|
        round.next_rounds.empty?
      end

      expect(rounds.length).to eq(1)
      round = rounds[0]

      expect(round.previous_rounds.length).to eq(2)
    end

    it "has an intermediate round connected to the start and end round" do
      rounds = @tournament.rounds.filter do |round|
        round.previous_rounds.any? and round.next_rounds.any?
      end
      expect(rounds.length).to eq(1)
      round = rounds[0]
      expect(round.players.length).to eq(2)
    end
  end

  context "with 8 people" do
    before(:each) do
      generate_players(8)
      @tournament.generate_rounds
      @tournament.save
    end

    it "has three rounds" do
      expect(@tournament.rounds.length).to eq(3)
    end

    it "has two starting rounds with non-overlapping players" do
      starting_rounds = @tournament.rounds.filter do |round|
        round.previous_rounds.empty?
      end
      players = starting_rounds.flatten.flat_map { |round| round.players }

      expect(starting_rounds.length).to eq(2)
      expect(players.uniq!).to be_nil
    end
  end
end
