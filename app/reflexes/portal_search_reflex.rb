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
    dup = dup.sort_by { |ctx| ctx[1] }.map { |ctx| ctx[0] }[..6]
    render_ctx = ""
    dup.each do |ctx|
      render_ctx += render(PortalSearchResultItemComponent.new(coordinate: ctx), layout: false)
    end
    if render_ctx.empty?
      render_ctx = %(
      <div role="alert"class="border w-full mb-3 px-4 py-3 rounded-lg relative max-w-screen-sm bg-red-100 border-red-400 text-red-700 text-center">
        <strong class="font-medium text-center">未找到结果</strong>
      </div>
      )
    end
    morph '#results', render_ctx
  end
end
