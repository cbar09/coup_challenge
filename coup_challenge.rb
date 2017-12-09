#!/usr/bin/env ruby
require 'json'

class CoupChallenge
  
  attr_accessor :scooters, :c, :p, :solution
  RANGE_NUM_DISTRICTS = (1..100)
  RANGE_NUM_SCOOTERS = (0..1000)
  RANGE_FM = (1..999)
  RANGE_FE = (1..1000)
  
  def initialize(n = [], c = 0, p = 0)
    @scooters, @c, @p = n, c, p
    @solution = Hash.new(@scooters.length)
  end
  
  def self.random
    self.new(Array.new(rand(RANGE_NUM_DISTRICTS)) { rand(RANGE_NUM_SCOOTERS) }, rand(RANGE_FM), rand(RANGE_FE))
  end
  
  def total_scooters
    @scooters.reduce( :+ )
  end
  
  def num_fleet_engineers(num_scooters)
    (num_scooters / @p.to_f).ceil
  end
  
  def num_fleet_engineers_with_fm(num_scooters)
    ([0, (num_scooters - @c)].max / @p.to_f).ceil
  end
  
  def max_engineers_can_be_saved
    (@c / @p.to_f).ceil
  end

  def number_fe_saved(num_scooters)
    num_fleet_engineers(num_scooters) - num_fleet_engineers_with_fm(num_scooters)
  end

  def solve
    return 0 if @scooters.empty?
  
    max_fe_saved_theoretical = max_engineers_can_be_saved
    max_fe_saved = 0
    total_FE = 0
  
    @scooters.each_with_index do |i, index|
      max_fe_saved = [max_fe_saved, number_fe_saved(i)].max if max_fe_saved < max_fe_saved_theoretical
      num_fe = self.num_fleet_engineers(i) 
      total_FE += num_fe
    
      @solution[index] = {
        num_scooters: i,
        num_fe_only: num_fe,
        max_fe_saved_so_far: max_fe_saved
      }
    end
  
    return total_FE - max_fe_saved
  end
  
  def show_solution
   JSON.pretty_generate(@solution)
  end
  
end

