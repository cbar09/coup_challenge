# myapp.rb
require 'sinatra'
require_relative 'coup_challenge'

get '/' do
  NUM_DISTRICTS = (1..100)
  NUM_SCOOTERS = (0..1000)
  c = ARGV.length >= 1 ? ARGV[0].to_i : rand(1..10)
  p = ARGV.length >= 2 ? ARGV[1].to_i : rand(1..15)
  n = ARGV.length >= 3 ? ARGV[2].split(',').map(&:to_i) : Array.new(rand(NUM_DISTRICTS)) { rand(NUM_SCOOTERS) }

  puts "scooters[] => #{n}"
  puts "C: #{c}"
  puts "P: #{p}"

  max_saved = max_engineers_can_be_saved(c, p)
  min_saved = min_engineers_can_be_saved(c, p)
  puts "The maximum number of FE's we can save is: #{max_saved}"
  puts "The minimum number of FE's we can save is: #{min_saved}"

  min_fe = solve(n, c, p)
  total_scooters = n.reduce( :+ )
  puts "For this configuration of scooters, we need at least #{min_fe} Field Engineers"
  puts "Total number of scooters: #{total_scooters}"
  puts "Total scooters divided by P = #{total_scooters / p.to_f}"
  "For this configuration of scooters, we need at least #{min_fe} Field Engineers <br/>"
  "Total scooters divided by P = #{total_scooters / p.to_f}"
end