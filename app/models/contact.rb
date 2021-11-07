class Contact < ApplicationRecord

  # nameのバリデーション
  validates :name,
                presence: true,
                length: { maximum: 50 }

  # emailのバリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
                presence: true,
                length: { maximum: 255 },
                format: {with: VALID_EMAIL_REGEX}

  # messageのバリデーション
  validates :message, presence: true

  def send_contact_email
    ContactMailer.contact_email(self).deliver_now
  end
end
