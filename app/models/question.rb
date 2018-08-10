class Question < ApplicationRecord
  belongs_to :card
  has_many :options

  CATEGORY_RANGE = %w(multiple_choice true_false).freeze
  enum category: CATEGORY_RANGE.map{|c| [c, c]}.to_h
end
