class Card < ApplicationRecord
  has_many :media
  has_many :questions

  def is_locked
    id % 2 == 1
  end

  def share_count
    99
  end

  def like_count
    88
  end
end
