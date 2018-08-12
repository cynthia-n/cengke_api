class UserCard < ApplicationRecord
  belongs_to :user
  belongs_to :card

  extend EnumStatus

  STATUS = [
    [:unlock, 0, '已解锁'],
    [:learning, 1, '正在学'],
    [:finished, 2, '已学完']
  ].freeze

  enum_status 'STATUS'

end
