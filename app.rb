# myapp.rb
require 'sinatra'
require_relative 'coup_challenge'
require 'better_errors' if development?
require 'bundler/setup'

# Just in development!
configure :development do
  use BetterErrors::Middleware
  # you need to set the application root in order to abbreviate filenames
  # within the application:
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  NUM_DISTRICTS = (1..100)
  NUM_SCOOTERS = (0..1000)
  c = ARGV.length >= 1 ? ARGV[0].to_i : rand(1..999)
  p = ARGV.length >= 2 ? ARGV[1].to_i : rand(1..1000)
  n = ARGV.length >= 3 ? ARGV[2].split(',').map(&:to_i) : Array.new(rand(NUM_DISTRICTS)) { rand(NUM_SCOOTERS) }

  @coup_challenge = CoupChallenge.new(n, c, p)
  @min_fe = @coup_challenge.solve
  
  erb :show_challenge
end