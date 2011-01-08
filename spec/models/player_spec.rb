require 'spec_helper'

describe Player do
  it 'should generate a url the the players reddit account' do
    player = Player.new(:reddit_name => 'yelvert')
    player.reddit_url.should eql('http://www.reddit.com/user/yelvert')
  end
  
  it 'should generate a url to the players bfbcs stats' do
    player = Player.new(:game_name => 'yelvert', :platform => 'PC')
    player.bfbcs_url.should eql('http://bfbcs.com/stats_pc/yelvert')
  end
  
  it 'should build a player from the bfbc2 stats api' do
    api_return = '{
      "name": "yelvert",
      "platform": "pc",
      "rank": 30,
      "rank_name": "SECOND LIEUTENANT III",
      "veteran": 3,
      "score": 1094681,
      "level": 159,
      "kills": 4467,
      "deaths": 5009,
      "time": 370183.8,
      "elo": 330.939,
      "form": "-2",
      "date_lastupdate": "2011-01-03T20:19:17+00:00",
      "date_lastcheck": "2011-01-03T20:19:18+00:00",
      "lastcheck": "updated",
      "count_updates": 6,
      "general": {
          "accuracy": 0.761,
          "dogr": 120,
          "dogt": 112,
          "elo0": 482.946,
          "elo1": 498.273,
          "games": 447,
          "goldedition": 0,
          "losses": 226,
          "sc_assault": 21062,
          "sc_award": 575260,
          "sc_bonus": 61816,
          "sc_demo": 141232,
          "sc_general": 327550,
          "sc_objective": 56700,
          "sc_recon": 93142,
          "sc_squad": 48590,
          "sc_support": 94190,
          "sc_team": 41205,
          "sc_vehicle": 169795,
          "slevel": 0,
          "spm": 0,
          "spm0": 0,
          "spm1": 0,
          "srank": 0,
          "sveteran": 0,
          "teamkills": 90,
          "udogt": 0,
          "wins": 221,
          "score_rank": 114507
      },
      "queue": false,
      "queue_info": {
          "queuefull": "Queue is full"
      },
      "lastonline": "2011-01-07T05:55:57+00:00",
      "clantag": "CBB",
      "server": {
          "addr": "64.34.213.44:19567",
          "qport": 48888,
          "name": "! TBGclan.com | CONQ HARD GUNG HO STYLE!"
      }
    }'
    player = Player.new(:reddit_name => "yelvert", :game_name => "yelvert", :platform => "PC")
    player.build_from_api(JSON.parse(api_return))
    player.clan_tag.should eql("CBB")
    player.rank.should eql(30)
    player.rank_name.should eql("SECOND LIEUTENANT III")
    player.veteren_level.should eql(3)
    player.score.should eql(1094681)
    player.kills.should eql(4467)
    player.deaths.should eql(5009)
    player.time_played.should eql(370184)
    player.skill_level.should eql(331)
    player.last_update.should eql(Time.parse("2011-01-03T20:19:17+00:00"))
    player.lastcheck.should eql(Time.parse("2011-01-03T20:19:18+00:00"))
    player.accuracy.should eql(0.761)
    player.dog_tags_taken.should eql(112)
    player.games_played.should eql(447)
    player.losses.should eql(226)
    player.wins.should eql(221)
    player.assault_score.should eql(21062)
    player.engineer_score.should eql(141232)
    player.support_score.should eql(94190)
    player.recon_score.should eql(93142)
    player.vehicle_score.should eql(169795)
    player.award_score.should eql(575260)
    player.bonus_score.should eql(61816)
    player.general_score.should eql(327550)
    player.objective_score.should eql(56700)
    player.squad_score.should eql(48590)
    player.team_score.should eql(41205)
    player.team_kills.should eql(90)
    player.score_rank.should eql(114507)
    player.last_online.should eql(Time.parse("2011-01-07T05:55:57+00:00"))
    player.last_server_address.should eql("64.34.213.44:19567")
    player.last_server_name.should eql("! TBGclan.com | CONQ HARD GUNG HO STYLE!")
  end
end
