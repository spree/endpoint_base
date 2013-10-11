# Need to run the Rails and Sinatra specs separately so 
# their dependencies won't pollute each other.

task :spec do
  exitcode = 0
  puts "Running Rails specs ---------------------"
  system("FROM_RAKE=1 bundle exec rspec spec/rails")
  exitcode = 1 unless $?.exitstatus == 0

  puts "Running Sinatra specs -------------------"
  system("FROM_RAKE=1 bundle exec rspec spec/sinatra")
  exitcode = 1 unless $?.exitstatus == 0

  exit exitcode
end
