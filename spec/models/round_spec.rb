require 'rails_helper'

RSpec.describe Round, type: :model do
    context "#next_best_open_round" do
        before(:each) do 
            @round = Round.new
        end

        context "as a final round" do
            it "returns nil" do
                expect(@round.next_best_open_round).to be_nil
            end
        end

        context "with just one next round" do
            it "returns the next round if it has less than 4 players" do
                next_round = Round.new
                @round.next_rounds << next_round

                expect(@round.next_best_open_round).to eq(next_round)
            end

            it "returns nil if it has 4 players" do
                next_round = Round.new
                (1..4).each do |n|
                    next_round.players.build(name: n.to_s)
                end
                @round.next_rounds << next_round

                expect(@round.next_best_open_round).to be_nil
            end
        end

        context "with multiple next rounds" do
            it "returns the next round with the highest position" do
                n1 = Round.new(position: 5)
                n2 = Round.new(position: 6)

                @round.next_rounds << n1
                @round.next_rounds << n2

                expect(@round.next_best_open_round).to eq(n2)
            end

            it "returns the open round if the highest position is full" do
                n1 = Round.new(position: 5)
                n2 = Round.new(position: 6)

                (1..4).each do |n|
                    n2.players.build(name: n.to_s)
                end

                @round.next_rounds << n1
                @round.next_rounds << n2

                expect(@round.next_best_open_round).to eq(n1)
            end
        end
    end
end