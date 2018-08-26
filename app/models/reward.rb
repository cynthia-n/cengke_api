class Reward < ApplicationRecord
  belongs_to :chapter
  belongs_to :user

  CATEGORY_RANGE = %w(crystal_egg easter_egg).freeze
  enum category: CATEGORY_RANGE.map{|c| [c, c]}.to_h

  extend EnumStatus

  STATUS = [
    [:pending, 0, '显示计算中'],
    [:actived, 1, '已激活'],
    [:received, 2, '已领取']
  ].freeze

  enum_status 'STATUS'

  def receive
    self.status = 'received'
    self.save
  end

  def give
    Card.where(chapter_id: chapter_id, is_free: false).map{|c|
      a = UserCard.find_or_initialize_by(user_id: self.user_id, card_id: c.id)
      a.unlock_at ||= Time.now
      a.status ||= 'unlock'
      a.save
    }
    self.status = 'actived'
    self.save
  end

end
