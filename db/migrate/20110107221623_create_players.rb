class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :reddit_name
      t.string :game_name
      t.string :platform
      t.string :clan_tag
      t.integer :rank
      t.string :rank_name
      t.integer :veteren_level
      t.integer :score
      t.integer :kills
      t.integer :deaths
      t.integer :time_played
      t.integer :skill_level
      t.datetime :last_update
      t.datetime :lastcheck
      t.float :accuracy
      t.integer :dog_tags_taken
      t.integer :games_played
      t.integer :losses
      t.integer :wins
      t.integer :assault_score
      t.integer :engineer_score
      t.integer :support_score
      t.integer :recon_score
      t.integer :vehicle_score
      t.integer :award_score
      t.integer :bonus_score
      t.integer :general_score
      t.integer :objective_score
      t.integer :squad_score
      t.integer :team_score
      t.integer :team_kills
      t.integer :score_rank
      t.datetime :last_online
      t.string :last_server_address
      t.string :last_server_name

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
