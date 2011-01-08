namespace :badditors do
  desc "Fetch the latest redditors list"
  task :get => :environment do
    require 'net/http'
    Net::HTTP.start("www.reddit.com") do |http|
      resp = http.get("/r/badcompany2/stylesheet")
      File.open(File.join(Rails.root, "lib", "redditors.txt"), "wt") do |file|
        file.write(resp.body)
      end
    end
  end
  
  desc "Build redditors from list"
  task :build => :environment do
    require 'net/http'
    redditors = ""
    File.open(File.join(Rails.root, "lib", "redditors.txt")) do |file|
      redditors << file.read
    end
    redditors = redditors.split(".author")
    redditors.delete_at 0
    redditors.delete_at 0
    redditors.each_index do |i|
      redditors[i] =~ /\[href\$=\"\/(.*)\"\]\:after\s{\s\s\s\s\scontent\: \"\((.*)\)\[(.*)\]\"\s\s\s\s\s}/
      redditors[i] = {:reddit_name => $1.to_s, :game_name => $2.to_s, :platform => $3.to_s}
    end
    redditors.each do |r|
      if Player.where(:game_name => r[:game_name], :platform => r[:platform]).blank?
        reddit_url = URI.parse("http://www.reddit.com/user/#{CGI::escape(r[:reddit_name])}") rescue next
        unless Net::HTTP.get_response(reddit_url).class == Net::HTTPNotFound
          stats_url = URI.parse("http://api.bfbcs.com/api/#{r[:platform].downcase}?players=#{CGI::escape(r[:game_name])}&fields=general,online") rescue next
          api = JSON.parse(Net::HTTP.get(stats_url)) rescue next
          if api["error"]
            Rails.logger.info "Stat Fetch error -- #{api.inspect}"
            next
          end
          if api["players"].size == 1
            Rails.logger.info "Creating Player #{r.inspect} with #{api}"
            player = Player.new(r).build_from_api(api["players"][0])
            if player.save
              Rails.logger.info "Created Player #{player.inspect}"
            else
              Rails.logger.info "Failed to Create Player #{player.inspect}"
            end
          end
        end
      end
    end
  end
end