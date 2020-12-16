# frozen_string_literal: true

class PortalSearchReflex < ApplicationReflex
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
  def run(params)
    bin = params.split(",")[1]
    dup = []
    Tempfile.open("po_search-", Rails.root.join("tmp")) do |f|
      f.binmode
      f.write(Base64.decode64(bin))
      f.close
      portals = Portal.where.not(image_hash: nil).pluck(:latitude, :longitude, :image_hash).map do |latitude, longitude, image_hash|
        id = [latitude, longitude]
        hash = image_hash
        image = Phashion::Image.new(id)
        image.instance_variable_set(:@hash, hash.to_i)
        image
      end
      current_portal = Phashion::Image.new(f.path)
      current_portal.fingerprint
      portals.each do |portal|
        if current_portal.duplicate?(portal, threshold: 17)
          distance = current_portal.distance_from(portal)
          dup << [portal.filename, distance]
        end
      end
      f.unlink
    rescue Exception => e
      puts e.message
      f.close!
    end
    render_ctx = ""
    dup.each do |coor, i|
      render_ctx += "<div>confidence:#{i}</div></br><div>https://intel.ingress.com/?pll=#{coor[0]},#{coor[1]}</div>"
    end
    time = Time.now.to_i
    morph '#result', "<div class='border-2 border-black mb-2' id='result-#{time}'>#{render_ctx}</div>"
  end
end
