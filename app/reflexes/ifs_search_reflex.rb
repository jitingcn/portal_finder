# frozen_string_literal: true

class IfsSearchReflex < ApplicationReflex
  # Add Reflex methods in this file.
  #
  # All Reflex instances expose the following properties:
  #
  #   - connection - the ActionCable connection
  #   - channel - the ActionCable channel
  #   - request - an ActionDispatch::Request proxy for the socket connection
  #   - session - the ActionDispatch::Session store for the current visitor
  #   - url - the URL of the page that triggered the reflex
  #   - element - a Hash like object that represents the HTML element that triggered the reflex
  #   - params - parameters from the element's closest form (if any)
  #
  # Example:
  #
  #   def example(argument=true)
  #     # Your logic here...
  #     # Any declared instance variables will be made available to the Rails controller and view.
  #   end
  #
  # Learn more at: https://docs.stimulusreflex.com
  def info
    id = element.dataset["id"]
    col = element.dataset["col"]
    row = element.dataset["row"]
    portal_id = element.dataset["portal-id"].split(",").each(&:to_f)
    portal = Portal.find(portal_id)
    search_result = IfsSearchResult.where(duplicate: portal_id, column: col, row: row).last
    if portal == nil || search_result == nil
      morph "#popup-#{id}", "no information" # :nothing
      return
    end
    img_url = Rails.application.routes.url_helpers.rails_representation_url(search_result.result.variant(resize_to_limit: [600, 600]).processed, only_path: true)
    morph "#popup-#{id}", "<div class='mb-1 font-bold text-xl'>#{portal.name}</div><div class='mb-2 text-xs font-thin'>#{portal.coordinate}</div><div class='mb-1 w-32 h-20'><img class='w-32 h-20 object-cover' src='#{img_url}'></div><a class='text-xl' href='#{portal.intel_link}' target='_blank' rel='noopener noreferrer'>Intel Link</a>"
  end
end
