class Player < ActiveRecord::Base
  
  validates_presence_of :reddit_name, :game_name, :platform
  validates_uniqueness_of :reddit_name
  validates_uniqueness_of :game_name, :scope => :platform
  
  validate :get_stats_for_player
  
  jtable :baddit_rank, :reddit_name, :game_name, :platform, :score, :score_per_minute, :rank, :kills, :deaths
  
  def jtable_attribute_rank
    "#{self.rank_name} (#{self.rank})"
  end
  
  def jtable_attribute_score_per_minute
    self.score_per_minute
  end
  
  def jtable_attribute_reddit_name
    %Q[<a href="#{self.reddit_url}">#{self.reddit_name}</a>]
  end
  
  def jtable_attribute_game_name
    %Q[<a href="/players/#{self.id}">#{self.game_name}</a>]
  end
  
  def jtable_attribute_baddit_rank
    Player.order('score DESC').index(self)+1
  end
  
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
        else
          self.build_from_api({})
        end
      end
    end
  end
  
  def score_per_minute
    (self.score.nil? or self.time_played.nil? or (self.score.to_f/(self.time_played.to_i/60)).nan? or (self.score.to_f/(self.time_played.to_i/60)).infinite?) ? 0 : sprintf("%0.02f", self.score.to_f/(self.time_played.to_i/60))
  end
  
  def reddit_url
    "http://www.reddit.com/user/#{self.reddit_name}"
  end
  
  def bfbcs_url
    "http://bfbcs.com/stats_#{self.platform.downcase}/#{CGI::escape(self.game_name)}"
  end
  
  def build_from_api(api)
    self.clan_tag = api["clantag"].to_s rescue ""
    self.rank = api["rank"].to_i rescue 0
    self.rank_name = api["rank_name"].to_s rescue ""
    self.veteren_level = api["veteran"].to_i rescue 0
    self.score = api["score"].to_i rescue 0
    self.kills = api["kills"].to_i rescue 0
    self.deaths = api["deaths"].to_i rescue 0
    self.time_played = api["time"].to_f.round rescue 0
    self.skill_level = api["elo"].to_f.round rescue 0
    self.last_update = Time.parse(api["date_lastupdate"]) rescue nil
    self.lastcheck = Time.parse(api["date_lastcheck"]) rescue nil
    self.accuracy = api["general"]["accuracy"].to_f rescue 0
    self.dog_tags_taken = api["general"]["dogt"].to_i rescue 0
    self.games_played = api["general"]["games"].to_i rescue 0
    self.losses = api["general"]["losses"].to_i rescue 0
    self.wins = api["general"]["wins"].to_i rescue 0
    self.assault_score = api["general"]["sc_assault"].to_i rescue 0
    self.engineer_score = api["general"]["sc_demo"].to_i rescue 0
    self.support_score = api["general"]["sc_support"].to_i rescue 0
    self.recon_score = api["general"]["sc_recon"].to_i rescue 0
    self.vehicle_score = api["general"]["sc_vehicle"].to_i rescue 0
    self.award_score = api["general"]["sc_award"].to_i rescue 0
    self.bonus_score = api["general"]["sc_bonus"].to_i rescue 0
    self.general_score = api["general"]["sc_general"].to_i rescue 0
    self.objective_score = api["general"]["sc_objective"].to_i rescue 0
    self.squad_score = api["general"]["sc_squad"].to_i rescue 0
    self.team_score = api["general"]["sc_team"].to_i rescue 0
    self.team_kills = api["general"]["teamkills"].to_i rescue 0
    self.score_rank = api["general"]["score_rank"].to_i rescue 0
    self.last_online = Time.parse(api["lastonline"]) rescue nil
    self.last_server_address = api["server"]["addr"].to_s rescue nil
    self.last_server_name = api["server"]["name"].to_s rescue nil
    self
  end
end
