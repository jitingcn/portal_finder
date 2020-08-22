require 'test_helper'

class IfsSearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ifs_search = ifs_searches(:one)
  end

  test "should get index" do
    get ifs_searches_url
    assert_response :success
  end

  test "should get new" do
    get new_ifs_search_url
    assert_response :success
  end

  test "should create ifs_search" do
    assert_difference('IfsSearch.count') do
      post ifs_searches_url, params: { ifs_search: {  } }
    end

    assert_redirected_to ifs_search_url(IfsSearch.last)
  end

  test "should show ifs_search" do
    get ifs_search_url(@ifs_search)
    assert_response :success
  end

  test "should get edit" do
    get edit_ifs_search_url(@ifs_search)
    assert_response :success
  end

  test "should update ifs_search" do
    patch ifs_search_url(@ifs_search), params: { ifs_search: {  } }
    assert_redirected_to ifs_search_url(@ifs_search)
  end

  test "should destroy ifs_search" do
    assert_difference('IfsSearch.count', -1) do
      delete ifs_search_url(@ifs_search)
    end

    assert_redirected_to ifs_searches_url
  end
end
