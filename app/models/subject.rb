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

  def cards
    Card.includes(:chapter).where(chapters: {subject_id: self.id})
  end

  def learning_count
    (self.learning_base_count || 666) + (real_learning_count || 0) * 5
  end

  def real_learning_count
    Rails.cache.fetch("subject_real_learning_count_#{self.id}", expires_in: 5.minutes) do
      UserCard.includes(card: [:chapter]).where(chapters: {subject_id: self.id}).select("distinct(user_id)").count
    end
  end

  def learning_users
    Rails.cache.fetch("subject_learning_users_#{self.id}", expires_in: 5.minutes) do
      self.status == 'pending' ? [] : User.order(id: :desc).limit(4).map{|c|{
        avatar: c.avatar
      }}
    end
  end

end
