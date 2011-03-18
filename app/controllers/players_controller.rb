class PlayersController < ApplicationController
  def index
    respond_to do |wants|
      wants.html {}
      wants.json {
        @players = Player.jtable_query(params[:jTableQuery])
        if params[:jTableQuery][:sort_column].blank?
          @players = @players.order('score DESC')
        end
        render :json => jtable_for_json(@players, params[:jTableQuery])
      }
    end
  end

  def show
    @player = Player.find params[:id]
    @player_attributes = [
      "reddit_name",
      "game_name",
      "platform",
      "clan_tag",
      "rank",
      "rank_name",
      "veteren_level",
      "score",
      "kills",
      "deaths",
      "time_played",
      "skill_level",
      "last_update",
      "lastcheck",
      "accuracy",
      "dog_tags_taken",
      "games_played",
      "losses",
      "wins",
      "assault_score",
      "engineer_score",
      "support_score",
      "recon_score",
      "vehicle_score",
      "award_score",
      "bonus_score",
      "general_score",
      "objective_score",
      "squad_score",
      "team_score",
      "team_kills",
      "score_rank",
      "last_online",
      "last_server_address",
      "last_server_name"
    ]
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new params[:player]
    if @player.save
      redirect_to(@player, :notice => "Player successfully added.")
    else
      render(:new)
    end
  end

  def update
    @player = Player.find params[:id]
    @player.update
    render :head => :ok
  end
end
