# frozen_string_literal: true

class PortalBatchCreateJob < ApplicationJob
  queue_as :portal_job

  def perform(arg)
    return if (arg.nil? || arg[:items].nil?)
    items = arg[:items]
    items.each do |item|
      latitude  = item[:latitude].to_f  / 1000000.0
      longitude = item[:longitude].to_f / 1000000.0
      image_url = item[:url]
      name = JSON.parse("\"#{item[:name]}\"")
      portal = Portal.find_by(latitude: latitude, longitude: longitude)
      if portal.nil?
        Portal.create(latitude: latitude, longitude: longitude, name: name, image_url: image_url)
      else
        force = true
        if portal.image_url == image_url
          force = false
        end
        portal.update(name: name, image_url: image_url)
        portal.save
        portal.set_image_hash(true) if force
      end
    end
  end
end
