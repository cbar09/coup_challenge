# File:  test_coup_challenge.rb

require_relative "coup_challenge"
require "test/unit"
 
class TestCoupChallenge < Test::Unit::TestCase
  
  def setup
    @coup_obj = CoupChallenge.new
  end
  
  def teardown
    ## nothing
  end 
  
  def test_default_init
    assert_true(@coup_obj.check_inputs)
    assert_equal(0, @coup_obj.total_scooters)
    # num_scooters, num_fe, num_fe_with_fm, max_saved, actual_saved solution_fe
    test_coup_numbers(0, 0, 0, 1, 0)
  end
  
  def test_total_scooters
    @coup_obj.scooters = [1, 1]
    assert_equal(2, @coup_obj.total_scooters)
  end
  
  def test_random_valid_coup
    1000.times do 
      @coup_obj = CoupChallenge.random
      assert_true(@coup_obj.check_inputs)
    end
  end
  
  # These should all return false for CoupChallenge.check_inputs
  def test_invalid_coup_params
    #scooters too big
    assert_false(CoupChallenge.new(scooters: Array.new(101), c: 1, p: 1).check_inputs)
    
    #scooters too small
    assert_false(CoupChallenge.new(scooters: [], c: 1, p: 1).check_inputs)
    
    #c too big
    assert_false(CoupChallenge.new(scooters: [1], c: 1000, p: 1).check_inputs)
    
    #c too small
    assert_false(CoupChallenge.new(scooters: [1], c: 0, p: 1).check_inputs)
    
    #p too big
    assert_false(CoupChallenge.new(scooters: [1], c: 1, p: 1001).check_inputs)
    
    #p too small
    assert_false(CoupChallenge.new(scooters: [1], c: 1, p: 0).check_inputs)
    
    #scooters[i] too big
    assert_false(CoupChallenge.new(scooters: [1001], c: 1, p: 1001).check_inputs)
    
    #scooters[i] too small
    assert_false(CoupChallenge.new(scooters: [-1], c: 1, p: 1001).check_inputs)
  end
  
  def test_single_scooter
    @coup_obj = CoupChallenge.new(scooters: [1], c: 1, p: 1)
    assert_true(@coup_obj.check_inputs)
    
    # num_scooters, num_fe, num_fe_with_fm, max_saved, actual_saved
    test_coup_numbers(@coup_obj.scooters[0], 1, 0, 1, 1)
  end
  
  def test_two_scooters
    @coup_obj = CoupChallenge.new(scooters: [2], c: 1, p: 1)
    assert_true(@coup_obj.check_inputs)
    
    # num_scooters, num_fe, num_fe_with_fm, max_saved, actual_saved
    test_coup_numbers(@coup_obj.scooters[0], 2, 1, 1, 1)
  end
  
  def test_number_FE
    # if scooters[0] == 0, then num_fe should be 0
    @coup_obj = CoupChallenge.new(scooters: [0], c: 1, p: 2)
    assert_equal(0, @coup_obj.num_fleet_engineers(@coup_obj.scooters[0]))
    
    # if p == scooters[0], then num_fe should be 1
    @coup_obj = CoupChallenge.new(scooters: [2], c: 1, p: 2)
    assert_equal(1, @coup_obj.num_fleet_engineers(@coup_obj.scooters[0]))
    
    # if p > scooters[0], then num_fe should also be 1
    @coup_obj.p = 3
    assert_equal(1, @coup_obj.num_fleet_engineers(@coup_obj.scooters[0]))
    
    # if p << scooters[0], then num_fe should be ceiling(scooters[0] / p)
    @coup_obj = CoupChallenge.new(scooters: [5], c: 1, p: 2)
    assert_equal((5/2.to_f).ceil, @coup_obj.num_fleet_engineers(@coup_obj.scooters[0]))
  end
  
  def test_number_FE_with_FM
    # if scooters[0] == 0, then num_fe_with_fm should be 0
    @coup_obj = CoupChallenge.new(scooters: [0], c: 1, p: 2)
    assert_equal(0, @coup_obj.num_fleet_engineers_with_fm(@coup_obj.scooters[0]))
    
    # if p >= scooters[0], then num_fe_with_fm should be 0 if c >= scooters[0], else 1
    @coup_obj = CoupChallenge.new(scooters: [2], c: 1, p: 2)
    assert_equal(1, @coup_obj.num_fleet_engineers_with_fm(@coup_obj.scooters[0]))
    
    @coup_obj = CoupChallenge.new(scooters: [2], c: 2, p: 3)
    assert_equal(0, @coup_obj.num_fleet_engineers_with_fm(@coup_obj.scooters[0]))
    
    @coup_obj = CoupChallenge.new(scooters: [2], c: 3, p: 3)
    assert_equal(0, @coup_obj.num_fleet_engineers_with_fm(@coup_obj.scooters[0]))
    
    # if p < scooters[0], then num_fe should be 0 if c >= scooters[0], else num_fe(scooters[0] - c)
    @coup_obj = CoupChallenge.new(scooters: [3], c: 10, p: 2)
    assert_equal(0, @coup_obj.num_fleet_engineers_with_fm(@coup_obj.scooters[0]))
    
    @coup_obj = CoupChallenge.new(scooters: [3], c: 3, p: 2)
    assert_equal(0, @coup_obj.num_fleet_engineers_with_fm(@coup_obj.scooters[0]))
    
    @coup_obj = CoupChallenge.new(scooters: [3], c: 2, p: 2)
    assert_equal(@coup_obj.num_fleet_engineers(@coup_obj.scooters[0] - @coup_obj.c), 
      @coup_obj.num_fleet_engineers_with_fm(@coup_obj.scooters[0]))
  end
  
  def test_max_saved
    # c <= p, max engineers saved (theoretical) will always be 1 
    @coup_obj = CoupChallenge.new(scooters: [0], c: 2, p: 3)
    assert_equal(1, @coup_obj.max_engineers_can_be_saved)
    
    # else it will be ceiling(c / p)
    @coup_obj = CoupChallenge.new(scooters: [0], c: 3, p: 2)
    assert_equal(2, @coup_obj.max_engineers_can_be_saved)
    
    # theoretical max must always be greater than actual saved max
    # and solution must be equal to total number_FE - max_actual_saved
    1000.times do
      @coup_obj = CoupChallenge.random
      assert_true(@coup_obj.max_engineers_can_be_saved >= @coup_obj.max_actual_saved)
      assert_equal(@coup_obj.solve, @coup_obj.total_fe_without_fm - @coup_obj.max_actual_saved)
    end
  end
  
  private
    def test_coup_numbers(num_scooters, num_fe, num_fe_with_fm, max_saved, actual_saved)
      assert_equal(num_fe,          @coup_obj.num_fleet_engineers(num_scooters))
      assert_equal(num_fe_with_fm,  @coup_obj.num_fleet_engineers_with_fm(num_scooters))
      assert_equal(max_saved,       @coup_obj.max_engineers_can_be_saved)
      assert_equal(actual_saved,    @coup_obj.number_fe_saved(num_scooters))
    end
 
end