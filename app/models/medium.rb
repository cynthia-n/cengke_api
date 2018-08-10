class Medium < ApplicationRecord
  belongs_to :card

  CATEGORY_RANGE = %w(image audio video).freeze
  enum category: CATEGORY_RANGE.map{|c| [c, c]}.to_h
end
