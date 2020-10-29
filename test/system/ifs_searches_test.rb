# frozen_string_literal: true

require "application_system_test_case"

class IfsSearchesTest < ApplicationSystemTestCase
  setup do
    @ifs_search = ifs_searches(:one)
  end

  test "visiting the index" do
    visit ifs_searches_url
    assert_selector "h1", text: "Ifs Searches"
  end

  test "creating a Ifs search" do
    visit ifs_searches_url
    click_on "New Ifs Search"

    click_on "Create Ifs search"

    assert_text "Ifs search was successfully created"
    click_on "Back"
  end

  test "updating a Ifs search" do
    visit ifs_searches_url
    click_on "Edit", match: :first

    click_on "Update Ifs search"

    assert_text "Ifs search was successfully updated"
    click_on "Back"
  end

  test "destroying a Ifs search" do
    visit ifs_searches_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ifs search was successfully destroyed"
  end
end
