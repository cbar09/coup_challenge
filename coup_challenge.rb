#!/usr/bin/env ruby
require 'pp'


def num_fleet_engineers(n, p)
  return (n / p.to_f).ceil
end

def num_fleet_engineers_with_fm(n, c, p)
  return ((n - c) / p.to_f).ceil
end

def max_engineers_can_be_saved(c, p)
  return (c / p.to_f).ceil
end

def min_engineers_can_be_saved(c, p)
  return max_engineers_can_be_saved(c, p) - 1
end

def number_fe_saved(num_scooters, c, p)
  num_fe_only = (num_scooters / p.to_f).ceil
  num_fe_with_fm = ([0, (num_scooters - c)].max / p.to_f).ceil
  puts "Number FE Saved for #{num_scooters} scooters: #{num_fe_only - num_fe_with_fm}"
  return num_fe_only - num_fe_with_fm
end

def can_save_max?(num_scooters, c, p)
  puts "num_scooters: #{num_scooters} | C: #{c} | P: #{p}"
  return max_engineers_can_be_saved(c, p) == number_fe_saved(num_scooters, c, p)
end

def solve(scooters, c, p)
  return 0 if scooters.empty?
  
  solution = Hash.new(scooters.length)
  
  # max = false #if we find a district where we can save the max
   max_fe_saved_theoretical = max_engineers_can_be_saved(c, p)
   max_fe_saved = 0
   total_FE = 0
  
  scooters.each_with_index do |i, index|
    max_fe_saved = [max_fe_saved, number_fe_saved(i, c, p)].max if max_fe_saved < max_fe_saved_theoretical
    num_fe = num_fleet_engineers(i, p) 
    total_FE += num_fe
    
    solution[index] = {
      scooters: i,
      num_fe_only: num_fe,
      num_fe_saved: max_fe_saved
    }
  end
  
  puts "Total_FE: #{total_FE}"
  puts "Max Saved: #{max_fe_saved}"
  pp solution
  return total_FE - max_fe_saved
end