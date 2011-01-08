class LeaderboardController < ApplicationController
  def index
    @players = Player.order('score DESC')
  end
end
