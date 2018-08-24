class Cengke < ApplicationRecord
  belongs_to :card
  belongs_to :user

  validate :validate_cengke

  before_save :set_cengke_status

  before_save :set_is_new_friend
  after_save :user_unlock_card

  scope :week_cengke, -> {
    where("created_at between ? and ?",
      Time.now.beginning_of_week,
      Time.now.end_of_week)
  }

  def set_cengke_status
    self.fail = false
    unless self.card.is_free
      if Cengke.where(source_user_id: self.source_user_id, card_id: self.card_id, fail: false).count >= 20
        self.fail = true
        self.error = '该卡片已蹭完'
      elsif Cengke.where(user_id: self.user_id, fail: false).week_cengke.count >= 30
        self.fail = true
        self.error = '本周蹭课机会已用完'
      end
    end
  end

  def validate_cengke
    if self.user_id == self.source_user_id
      errors.add(:source_user_id, "不能蹭自己的课")
    end
  end

  def set_is_new_friend
    self.is_new_friend = Reward.where(
      user_id: self.source_user_id,
      chapter_id: self.card.chapter_id
    ).present? && Cengke.where(
      source_user_id: self.source_user_id,
      user_id: self.user_id
    ).blank?
  end

  def user_unlock_card
    if self.fail == false
      a = UserCard.find_or_initialize_by(user_id: self.user_id, card_id: self.card_id)
      a.unlock_at ||= Time.now
      a.status ||= 'unlock'
      a.save
    end
    chapter_id =  self.card.chapter_id
    chapter_new_friend_size = Cengke.includes(:card).where(
      source_user_id: self.source_user_id,
      is_new_friend: true,
      cards: {chapter_id: chapter_id}
    ).count
    if chapter_new_friend_size >= 3
      reward = Reward.find_or_initialize_by(
        user_id: self.source_user_id,
        chapter_id: chapter_id,
        category: 'crystal_egg'
      )
      if reward.status == 'pending'
        reward.status = 'actived'
        reward.save
      end
    end
  end
end
