if ENV['FROM_RAKE'].nil?
  puts "Please run specs with `bundle exec rake spec`"
  exit 1
end

