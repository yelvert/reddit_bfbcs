class PlayersController < ApplicationController
  def index
    @players = Player.order('score DESC')
  end

  def show
    @player = Player.find params[:id]
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
