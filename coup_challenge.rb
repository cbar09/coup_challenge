#!/usr/bin/env ruby
require 'json'

class CoupChallenge
  
  attr_accessor :scooters, :c, :p
  RANGE_NUM_DISTRICTS = (1..100)
  RANGE_NUM_SCOOTERS = (0..1000)
  RANGE_FM = (1..999)
  RANGE_FE = (1..1000)
  
  def initialize(scooters: [0], c: 1, p: 1)
    @scooters, @c, @p = scooters, c, p
  end
  
  def check_inputs
    return CoupChallenge.check_inputs(self.scooters, self.c, self.p)
  end
  
  def self.check_inputs(scooters, c, p)
    if scooters.nil? || scooters.empty?
      return false
    else
      valid_scooters = (RANGE_NUM_DISTRICTS === scooters.count && 
        scooters.all?{|s| RANGE_NUM_SCOOTERS === s})
    end
      
    return valid_scooters && RANGE_FM === c && RANGE_FE === p
  end
  
  def self.random
    self.new(scooters: Array.new(rand(RANGE_NUM_DISTRICTS)) { rand(RANGE_NUM_SCOOTERS) }, 
      c: rand(RANGE_FM), p: rand(RANGE_FE))
  end
  
  def total_scooters
    @scooters.inject(0){|sum,x| sum + x }
  end
  
  def number_districts
    @scooters.count
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
  
  def max_actual_saved
    scooters.map{|s| number_fe_saved(s)}.max
  end
  
  def total_fe_without_fm
    scooters.map{|s| num_fleet_engineers(s)}.reduce(:+)
  end

  def solve
    return num_fleet_engineers_with_fm(@scooters[0]) if @scooters.count == 1
  
    max_fe_saved_theoretical = max_engineers_can_be_saved
    max_fe_saved = 0
    total_FE = 0
  
    @scooters.each_with_index do |i, index|
      max_fe_saved = [max_fe_saved, number_fe_saved(i)].max if max_fe_saved < max_fe_saved_theoretical
      num_fe = self.num_fleet_engineers(i) 
      total_FE += num_fe
    end
  
    return total_FE - max_fe_saved
  end
end