class Player < ActiveRecord::Base
  
  def self.build_from_api(reddit, api_json)
    api = JSON.parse(api_json)
    Player.new(
      :reddit_name => reddit,
      :game_name => api["name"],
      :platform => api["platform"],
      :clan_tag => api["clantag"],
      :rank => api["rank"],
      :rank_name => api["rank_name"],
      :veteren_level => api["veteran"],
      :score => api["score"],
      :kills => api["kills"],
      :deaths => api["deaths"],
      :time_played => api["time"].round,
      :skill_level => api["elo"].round,
      :last_update => Time.parse(api["date_lastupdate"]),
      :lastcheck => Time.parse(api["date_lastcheck"]),
      :accuracy => api["general"]["accuracy"],
      :dog_tags_taken => api["general"]["dogt"],
      :games_played => api["general"]["games"],
      :losses => api["general"]["losses"],
      :wins => api["general"]["wins"],
      :assault_score => api["general"]["sc_assault"],
      :engineer_score => api["general"]["sc_demo"],
      :support_score => api["general"]["sc_support"],
      :recon_score => api["general"]["sc_recon"],
      :vehicle_score => api["general"]["sc_vehicle"],
      :award_score => api["general"]["sc_award"],
      :bonus_score => api["general"]["sc_bonus"],
      :general_score => api["general"]["sc_general"],
      :objective_score => api["general"]["sc_objective"],
      :squad_score => api["general"]["sc_squad"],
      :team_score => api["general"]["sc_team"],
      :team_kills => api["general"]["teamkills"],
      :score_rank => api["general"]["score_rank"],
      :last_online => Time.parse(api["lastonline"]),
      :last_server_address => api["server"]["addr"],
      :last_server_name => api["server"]["name"]
    )
  end
end
