class Share < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  validates :share_key, presence: true, uniqueness: true
end
