# frozen_string_literal: true

class PortalSearchResultItemComponent < ViewComponent::Base
  def initialize(coordinate:)
    if coordinate.length != 2
      portal = nil
      return
    end
    portal = Portal.find_by(latitude: coordinate[0], longitude: coordinate[1])

    return unless portal
    @name = portal.name
    @coordinate = portal.coordinate
    @image_url = portal.image_url
    @link = "https://intel.ingress.com/?pll=#{portal.coordinate}"
    @raw = { "name": @name, "coordinate": @coordinate, "image_url": @image_url }.to_json
  end

  def render?
    true unless @name.empty?
  end
end
