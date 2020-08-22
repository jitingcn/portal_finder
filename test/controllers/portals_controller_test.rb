require "test_helper"

class PortalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @portal = portals(:one)
  end

  test "should get index" do
    get portals_url
    assert_response :success
  end

  test "should get new" do
    get new_portal_url
    assert_response :success
  end

  test "should create portal" do
    assert_difference('Portal.count') do
      post portals_url, params: { portal: {  } }
    end

    assert_redirected_to portal_url(Portal.last)
  end

  test "should show portal" do
    get portal_url(@portal)
    assert_response :success
  end

  test "should get edit" do
    get edit_portal_url(@portal)
    assert_response :success
  end

  test "should update portal" do
    patch portal_url(@portal), params: { portal: {  } }
    assert_redirected_to portal_url(@portal)
  end

  test "should destroy portal" do
    assert_difference('Portal.count', -1) do
      delete portal_url(@portal)
    end

    assert_redirected_to portals_url
  end
end
