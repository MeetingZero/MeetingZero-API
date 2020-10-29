God.watch do |w|
  w.name = "anycable-rpc"
  w.start = "RAILS_ENV=staging bundle exec anycable"
  w.group = "anycable"
end

God.watch do |w|
  w.name = "anycable-go"
  w.start = "anycable-go --port=8080"
  w.group = "anycable"
end

God.watch do |w|
  w.name = "resque-pool"
  w.start = "RAILS_ENV=staging bundle exec resque-pool"
end
