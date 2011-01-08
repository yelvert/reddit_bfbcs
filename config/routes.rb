RedditBFBC2::Application.routes.draw do
  get "leaderboard/index"
  root :to => "leaderboard#index"
end
