# frozen_string_literal: true

class IfsSearchResult < ApplicationRecord
  belongs_to :ifs_search, class_name: "IfsSearch", foreign_key: "ifs_searches_id"

  has_one_attached :result

  validates :result, content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
            size: { less_than: 10.megabytes,
                    message: "should be less than 10MB" }

  def to_phashion
    Tempfile.open("ifs_results-", Rails.root.join("tmp")) do |f|
      f.binmode
      f.write(result.download)
      f.close
      image = Phashion::Image.new(f.path)
      self.image_hash = image.fingerprint
      self.save
      return image
    end
  end

  def get_phashion_object(id: nil, hash: nil)
    return unless id && hash

    image = Phashion::Image.new(id)
    image.instance_variable_set(:@hash, hash.to_i)
    image
  end

  def find_duplicate(debug = false)
    dup = []
    portals = Portal.where.not(image_hash: nil).pluck(:latitude, :longitude, :image_hash).map do |latitude, longitude, image_hash|
      self.get_phashion_object(id: [latitude, longitude], hash: image_hash)
    end
    current_portal = self.to_phashion
    portals.each do |portal|
      if current_portal.duplicate?(portal, threshold: 20)
        dup << portal.filename
      end
    end
    if debug && dup.size > 0
      puts "find duplicate portals: "
      dup.each do |portal|
        puts Portal.find(portal).to_json
      end
    end
    if dup.size > 0
      self.duplicate = dup.first
      self.save
    end
    self
  end
end
