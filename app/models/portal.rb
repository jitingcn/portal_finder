# frozen_string_literal: true

class Portal < ApplicationRecord
  self.primary_key = [:latitude, :longitude]
  reverse_geocoded_by :latitude, :longitude

  after_initialize :set_image_hash, if: :new_record?

  def coordinate
    [self.latitude, self.longitude].compact.join(",")
  end

  def address
    [self.province, self.city].compact.join
  end

  def address=(address)
    regex = /(?<province>.*省)?(?<city>.*市)/
    address = address.match(regex)
    return false if address.nil?
    self.update({ city: address[:city], province: address[:province] })
  end

  def to_phashion
    image = Phashion::Image.new(self.id)
    image.instance_variable_set(:@hash, self.image_hash.to_i)
    image
  end

  def intel_link
    "https://intel.ingress.com/intel?ll=#{coordinate}&z=15&pll=#{coordinate}"
  end

  def find_duplicate(debug: false)
    dup = []
    portals = Portal.where.not(latitude: self.latitude).where.not(longitude: self.longitude).map { |x| x.to_phashion }
    current_portal = self.to_phashion
    portals.each do |portal|
      if current_portal.duplicate?(portal, threshold: 8)
        dup << portal.filename
      end
    end
    if debug && dup.size > 0
      puts "find duplicate portals: "
      puts self.to_json
      dup.each do |portal|
        puts Portal.find(portal).to_json
      end
    end
    dup
  end

  def set_image_hash(force: false)
    self.image_hash = nil if force

    if self.image_hash.nil? && !self.latitude.nil? && !self.longitude.nil?
      PortalSetImageHashJob.perform_later id: [self.latitude, self.longitude], image_url: self.image_url
    end
  end

  def set_city
    if self.city.nil? && !self.latitude.nil? && !self.longitude.nil?
      self.delay.reverse_geocode
    end
  end
end
