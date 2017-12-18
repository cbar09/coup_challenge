# myapp.rb
require 'sinatra'
require 'json'
require_relative 'coup_challenge'
require 'bundler/setup' #for heroku

if development?
  require 'better_errors' 
  require 'binding_of_caller'
end

# Just in development!
configure :development do
  use BetterErrors::Middleware
  # you need to set the application root in order to abbreviate filenames
  # within the application:
  BetterErrors.application_root = File.expand_path('~/coup_challenge', __FILE__)
end

before do
  
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
  
  begin
    scooters = params['scooters'].tr('(){}[]', '').split(',').map(&:to_i)
    c = params['C'].to_i
    p = params['P'].to_i
  rescue
    @error = "Input variables are not valid!"
    erb :show_challenge
  end
  
  #Inputs are valid integers, we can instantiate CoupChallenge
  @coup_challenge = CoupChallenge.new(scooters: scooters, c: params['C'].to_i, p: params['P'].to_i)
  
  if @coup_challenge.check_inputs
    @min_fe = @coup_challenge.solve
  else
    @error = "Input variables are not valid!"
  end
  
  # Render View
  erb :show_challenge
end

post '/solve.json' do
  #params parsing for api-style request
  params = JSON.parse(request.body.read)
  
  begin
    scooters = params['scooters'].tr('(){}[]', '').split(',').map(&:to_i)
    c = params['C'].to_i
    p = params['P'].to_i
  rescue
    @error = "Input variables are not valid!"
    erb :show_challenge
  end
  
  #Inputs are valid integers, we can instantiate CoupChallenge
  @coup_challenge = CoupChallenge.new(scooters: scooters, c: params['C'].to_i, p: params['P'].to_i)
  
  if @coup_challenge.check_inputs
    @min_fe = @coup_challenge.solve
    content_type :json
    {fleet_engineers: @min_fe}.to_json
  else
    content_type :json
    {errors: "Input variables are not valid!"}.to_json
  end
end