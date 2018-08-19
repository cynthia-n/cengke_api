class Cengke < ApplicationRecord
  belongs_to :card
  belongs_to :user

  validate :validate_cengke

  before_save :set_is_new_friend
  # after_save :user_unlock_card

  scope :today_cengke, -> {
    where("created_at between ? and ?",
      Time.now.beginning_of_day,
      Time.now.end_of_day)
  }

  def validate_cengke
    if self.user_id == self.source_user_id
      errors.add(:source_user_id, "不能蹭自己的课")
    end
    unless self.card.is_free
      if Cengke.where(source_user_id: self.source_user_id, card_id: self.card_id).count >= 20
        errors.add(:card_id, "该卡片已蹭完")
      end
      if Cengke.where(user_id: self.user_id).today_cengke.count >= 5
        errors.add(:card_id, "今日蹭课机会已用完")
      end
    end
  end

  def set_is_new_friend
    self.is_new_friend = Cengke.where(source_user_id: self.source_user_id, user_id: self.user_id).present?
  end

  # def user_unlock_card
  #   Cengke.where(user_id: self.user_id).where("created_at between #{} and #{}").count >= 5
  # end
end
