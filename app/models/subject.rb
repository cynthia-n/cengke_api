class Subject < ApplicationRecord
  extend EnumStatus

  has_many :chapters

  DISPLAY_SIZE_RANGE = ['big', 'small']
  enum display_size: DISPLAY_SIZE_RANGE.map{|c| [c, c]}.to_h

  STATUS = [
    [:pending, 0, '待上线'],
    [:published, 1, '已上线']
  ].freeze

  enum_status 'STATUS'

  def crowd_arr
    crowd&.split(",") || []
  end
end
