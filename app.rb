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
  @coup_challenge = nil
  erb :show_challenge
end

get '/random' do
  @coup_challenge = CoupChallenge.random
  erb :show_challenge
end

post '/solve' do
  scooters = params['scooters'].tr!('(){}[]', '').split(',').map(&:to_i)
  
  @coup_challenge = CoupChallenge.new(scooters, params['C'].to_i, params['P'].to_i)
  @min_fe = @coup_challenge.solve

  erb :show_challenge
end