class Player < ActiveRecord::Base
  
  validates_presence_of :reddit_name, :game_name, :platform
  validates_uniqueness_of :reddit_name
  validates_uniqueness_of :game_name, :scope => :platform
  
  validate :get_stats_for_player
  
  def get_stats_for_player
    reddit = URI.parse("http://www.reddit.com/user/#{CGI::escape(self.reddit_name)}")
    if Net::HTTP.get_response(reddit).class == Net::HTTPNotFound
      errors.add_to_base("That Reddit user does not seem to exist.")
    else
      stats_url = URI.parse("http://api.bfbcs.com/api/#{self.platform.downcase}?players=#{CGI::escape(self.game_name)}&fields=general,online")
      Net::HTTP.get(stats_url) =~ /(\{.*\}\Z)/
      api = JSON.parse($1)
      if api["error"]
        errors.add_to_base("Stat Fetch error -- #{api.inspect}")
        Rails.logger.info "Stat Fetch error -- #{api.inspect}"
      else
        if api["players"].size == 1
          self.build_from_api(api["players"][0])
        end
      end
    end
  end
  
  def reddit_url
    "http://www.reddit.com/user/#{self.reddit_name}"
  end
  
  def bfbcs_url
    "http://bfbcs.com/stats_#{self.platform.downcase}/#{CGI::escape(self.game_name)}"
  end
  
  def build_from_api(api)
    self.clan_tag = api["clantag"].to_s rescue nil
    self.rank = api["rank"].to_i rescue nil
    self.rank_name = api["rank_name"].to_s rescue nil
    self.veteren_level = api["veteran"].to_i rescue nil
    self.score = api["score"].to_i rescue nil
    self.kills = api["kills"].to_i rescue nil
    self.deaths = api["deaths"].to_i rescue nil
    self.time_played = api["time"].to_f.round rescue nil
    self.skill_level = api["elo"].to_f.round rescue nil
    self.last_update = Time.parse(api["date_lastupdate"]) rescue nil
    self.lastcheck = Time.parse(api["date_lastcheck"]) rescue nil
    self.accuracy = api["general"]["accuracy"].to_f rescue nil
    self.dog_tags_taken = api["general"]["dogt"].to_i rescue nil
    self.games_played = api["general"]["games"].to_i rescue nil
    self.losses = api["general"]["losses"].to_i rescue nil
    self.wins = api["general"]["wins"].to_i rescue nil
    self.assault_score = api["general"]["sc_assault"].to_i rescue nil
    self.engineer_score = api["general"]["sc_demo"].to_i rescue nil
    self.support_score = api["general"]["sc_support"].to_i rescue nil
    self.recon_score = api["general"]["sc_recon"].to_i rescue nil
    self.vehicle_score = api["general"]["sc_vehicle"].to_i rescue nil
    self.award_score = api["general"]["sc_award"].to_i rescue nil
    self.bonus_score = api["general"]["sc_bonus"].to_i rescue nil
    self.general_score = api["general"]["sc_general"].to_i rescue nil
    self.objective_score = api["general"]["sc_objective"].to_i rescue nil
    self.squad_score = api["general"]["sc_squad"].to_i rescue nil
    self.team_score = api["general"]["sc_team"].to_i rescue nil
    self.team_kills = api["general"]["teamkills"].to_i rescue nil
    self.score_rank = api["general"]["score_rank"].to_i rescue nil
    self.last_online = Time.parse(api["lastonline"]) rescue nil
    self.last_server_address = api["server"]["addr"].to_s rescue nil
    self.last_server_name = api["server"]["name"].to_s rescue nil
    self
  end
end
