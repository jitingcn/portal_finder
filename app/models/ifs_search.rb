# frozen_string_literal: true

class IfsSearch < ApplicationRecord
  belongs_to :user
  has_one_attached :request
  has_many :ifs_search_results, foreign_key: "ifs_searches_id", dependent: :destroy  # -> { where ifs_searches_id: id },

  validates :user_id, presence: true
  validates :title, presence: true
  validates :request, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
            size: { less_than: 10.megabytes,
                    message: "should be less than 10MB" }

  def split_image
    img = Magick::Image.from_blob(request.download).first
    bg_pixel = img.get_pixels(img.columns-5, img.rows-5, 1, 1).first
    img = img.trim(reset = true)

    width = img.columns
    height = img.rows
    img_list = []
    slices = (0..width).step(300).to_a
    unless slices.last == width
      slices << width
    end
    (slices.length - 1).times do |i|
      img_list << img.crop(slices[i], 0, slices[i + 1] - slices[i], height, true)
    end
    img_list.each do |img|
      img.fuzz = "5%"
      img.trim!(reset = true)
    end
    po_list = img_list.map do |val|
      make_portal_list(val, bg_pixel)
    end
    po_list.each_with_index do |pack, col|
      pack.each_with_index do |item, row|
        Tempfile.open("ifs_results-", Rails.root.join("tmp")) do |f|
          item.write(f.path)
          f.close
          ifs_search_result = ifs_search_results.create(column: col, row: row)
          ifs_search_result.result.attach(io: File.open(f.path), filename: "ifs_search_#{self.id}_#{col}_#{row}.jpg")
          ifs_search_result.find_duplicate
          f.unlink
        rescue Exception => e
          puts e.message
          f.close!
        end
      end
    end
  end
  # rescue Exception => e
  #   puts e.message


  def make_portal_list(test, bg_pixel)
    borders = []

    test.get_pixels(0,0,1,test.rows).each_with_index do |p,i|
      if p.fcmp(bg_pixel, (fuzz = 3500))
        borders << i + 1
      end
    end
    # borders_diff = (1..borders.length - 1).map do |i|
    #   borders[-i] - borders[-(i + 1)]
    # end.reverse!

    borders_clustering = []
    noises_set = []

    borders.each do |x|
      if x == test.rows
        noises_set << x
        next
      end
      match = 0
      test.get_pixels(0,x,test.columns,1).each do |p|
        if p.fcmp(bg_pixel, (fuzz = 1200))
          match += 1
        end
      end
      # puts "row(#{x}): #{match * 100 / test.columns}"
      if (match * 100 / test.columns) < 85
        noises_set << x
      end
    end
    noises_set.each { |n| borders.delete(n) }
    borders_clustering << [borders.first]
    borders.each do |i|
      if i == 0
        next
      end
      if (i - borders_clustering[-1][-1]).abs < 50
        borders_clustering[-1] << i
      else
        borders_clustering << [i]
      end
    end
    borders_clustering.map! do |i|
      if i.size == 1
        i.first.to_i 
      else
        i.sort!
        rank = 50 / 100.0 * (i.size - 1)
        lower, upper = i[rank.floor,2]
        (lower + (upper - lower) * (rank - rank.floor)).to_i
      end
    end
    borders_clustering.shift if borders_clustering.first < 80
    borders_clustering.unshift(0)
    borders_clustering << test.rows unless borders_clustering.last == test.rows
    (borders_clustering.size - 1).times.map do |i|
      test.fuzz = "8%"
      test.crop(0, borders_clustering[i], test.columns, borders_clustering[i + 1] - borders_clustering[i]).trim(reset = true)
    end
  # rescue Exception => e
  #   puts e.message
  end
end
