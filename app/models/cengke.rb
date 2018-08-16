class Cengke < ApplicationRecord
  belongs_to :card
  belongs_to :user

  validate :validate_cengke

  # before_save :set_is_new_friend
  # after_save :user_unlock_card

  def validate_cengke
    if self.user_id == self.source_user_id
      errors.add(:source_user_id, "不能蹭自己的课")
    end
    if self.card.is_free
      errors.add(:card_id, "免费课程不需要蹭课")
    end
  end

  # def set_is_new_friend
  #   self.is_new_friend = Cengke.where(source_user_id: self.source_user_id, user_id: self.user_id).present?
  # end

  # def user_unlock_card
  #   Cengke.where(user_id: self.user_id).where("created_at between #{} and #{}").count >= 5
  # end
end
