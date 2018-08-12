class Card < ApplicationRecord
  has_many :media
  has_many :questions
  belongs_to :chapter


  has_many :user_cards
  has_many :users, through: :user_cards

  def self.list_with_user(user_id)
    Card.joins("left join user_cards on user_cards.user_id = #{user_id} and user_cards.card_id = cards.id").distinct.select('cards.*, (case when user_cards.user_id is null then false else true end) AS unlocked')
  end

  def is_locked?(user_id = nil)
    raise 'need user' if user_id.blank? && self.try(:unlocked).blank?
    !(self.is_free || self.try(:unlocked) == 1 || self.user_cards.where(user_id: user_id).present?)
  end

  def share_count
    (share_base_count || 0) + real_share_count
  end

  def real_share_count
    88
  end

  def like_count
    (like_base_count || 0) + real_like_count
  end

  def real_like_count
    99
  end
end
