class LinkGroup < ApplicationRecord
  belongs_to :user
  has_many :links, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }

end
