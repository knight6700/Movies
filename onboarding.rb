require 'json'
require 'fileutils'

# Make sure all project ruby dependencies are installed
begin
  require 'bundler'
  require 'arkana'
  require 'fastlane'
rescue LoadError
  `sudo gem install bundler`
  `bundle update`
end

puts "Hello There!, Welcome to Movies"
puts "Basically this is just a simple quick script to setup Movies environment"
puts "As of now, we are using Arkana and Fastlane, so we will be needing the following..."

puts "1. AppleID"
puts "2. Apple Password"
puts "We will be using Fastlane's Credential Manager for this"
puts "Please enter your Apple ID"
apple_id = gets.chomp
system("fastlane fastlane-credentials add --username #{apple_id}")

puts "3. API_KEY_Debug for Movies"
ENV["MoviesAPIKeyDebug"] = gets.chomp
puts "4. API_KEY_Release for Movies"
ENV["MoviesAPIKeyRelease"] = gets.chomp
system("bundle exec arkana")
system("xed .")
puts "✅ All Done! ✅"
