require 'test_helper'

class DeliveryCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get delivery_categories_new_url
    assert_response :success
  end

  test "should get index" do
    get delivery_categories_index_url
    assert_response :success
  end

  test "should get show" do
    get delivery_categories_show_url
    assert_response :success
  end

  test "should get create" do
    get delivery_categories_create_url
    assert_response :success
  end

  test "should get update" do
    get delivery_categories_update_url
    assert_response :success
  end

  test "should get destroy" do
    get delivery_categories_destroy_url
    assert_response :success
  end

end