#!/usr/bin/env ruby
require 'json'

class CoupChallenge
  
  attr_accessor :scooters 
  attr_accessor :c 
  attr_accessor :p
  
  def initialize(n = [], c = 0, p = 0)
    @scooters, @c, @p = n, c, p
    @solution = Hash.new(@scooters.length)
  end
  
  def total_scooters
    @scooters.reduce( :+ )
  end
  
  def num_fleet_engineers(n)
    return (n / @p.to_f).ceil
  end
  
  def show_solution
   JSON.pretty_generate(@solution)
  end

  def max_engineers_can_be_saved
    return (@c / @p.to_f).ceil
  end
  
  def min_engineers_can_be_saved
    return [max_engineers_can_be_saved - 1, 0].max
  end

  def number_fe_saved(num_scooters)
    num_fe_only = (num_scooters / @p.to_f).ceil
    num_fe_with_fm = ([0, (num_scooters - @c)].max / @p.to_f).ceil
    return num_fe_only - num_fe_with_fm
  end

  def can_save_max?(num_scooters)
    return max_engineers_can_be_saved(@c, @p) == number_fe_saved(num_scooters, @c, @p)
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
        num_fe_saved: max_fe_saved
      }
    end
  
    return total_FE - max_fe_saved
  end

end

