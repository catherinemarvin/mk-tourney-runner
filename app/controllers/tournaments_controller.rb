class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)

    player_names = params[:players].split("\n")
    player_names.each do |name|
      @tournament.players.build(name: name)
    end

    @tournament.generate_rounds

    if @tournament.save!
      redirect_to @tournament
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def update
    @tournament = Tournament.find(params[:id])

    if @tournament.update(tournament_params)
      redirect_to @tournament
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def tournament_params
      params.require(:tournament).permit(:title)
    end
end
