# frozen_string_literal: true

module IfsSearchesHelper
  def coordinates(items)
    items.map do |item|
      unless item.duplicate.nil?
        item.duplicate.join(",")
      end
    end.join(";").gsub(/;{2,}/, "|")
  end
end
