# frozen_string_literal: true

require "application_system_test_case"

class PortalsTest < ApplicationSystemTestCase
  setup do
    @portal = portals(:one)
  end

  test "visiting the index" do
    visit portals_url
    assert_selector "h1", text: "Portals"
  end

  test "creating a Portal" do
    visit portals_url
    click_on "New Portal"

    click_on "Create Portal"

    assert_text "Portal was successfully created"
    click_on "Back"
  end

  test "updating a Portal" do
    visit portals_url
    click_on "Edit", match: :first

    click_on "Update Portal"

    assert_text "Portal was successfully updated"
    click_on "Back"
  end

  test "destroying a Portal" do
    visit portals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Portal was successfully destroyed"
  end
end
