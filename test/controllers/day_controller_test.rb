require 'test_helper'

class DayControllerTest < ActionDispatch::IntegrationTest
  test "should get monday" do
    get day_monday_url
    assert_response :success
  end

  test "should get tuesday" do
    get day_tuesday_url
    assert_response :success
  end

  test "should get wednesday" do
    get day_wednesday_url
    assert_response :success
  end

  test "should get thursday" do
    get day_thursday_url
    assert_response :success
  end

  test "should get friday" do
    get day_friday_url
    assert_response :success
  end

end
