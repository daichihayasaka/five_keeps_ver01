class Link < ApplicationRecord
  belongs_to :user
  belongs_to :link_group

  default_scope -> { order(updated_at: :desc) }

  validates :user_id, presence: true
  validates :link_group_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :url, presence: true
end
