class Share < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  validates :share_key, presence: true, uniqueness: true

  after_save :set_reward

  def set_reward
    if self.source_type == 'Card'
      card = Card.list_with_user(self.user_id).where(id: self.source_id).first
      if card.is_locked?
        reward = Reward.find_or_initialize_by(
          user_id: self.user_id,
          chapter_id: card.chapter_id,
          category: 'crystal_egg'
        )
        reward.status ||= 'pending'
        reward.save
      end
    end
  end
end
