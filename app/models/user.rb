class User < ApplicationRecord
  # 順番が逆だとlink_group_idがnullになり、エラーになる
  has_many :links, dependent: :destroy
  has_many :link_groups, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save   :downcase_email
  before_create :create_activation_digest

  # nameのバリデーション
  validates :name,
                presence: true,
                length: { maximum: 50 }

  # emailのバリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
                presence: true,
                length: { maximum: 255 },
                format: {with: VALID_EMAIL_REGEX},
                uniqueness: true

  # passwordのバリデーション
  has_secure_password
  validates :password,
                presence: true,
                length: { minimum: 6 },
                # 新規登録時に限り、存在性の検証はhas_secure_passwordが担っている
                allow_nil: true

  # 渡された文字列のハッシュ値を返す (BCrypt gemを利用)
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
              BCrypt::Engine::MIN_COST :
              BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのために、ユーザーのログイン情報をデータベースに記憶
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest") #User自身のdigestをDBから取得
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true,
                            activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                            reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
  end

  private
    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    # => Userオブジェクトが保存される際は、activation_digestも保存される
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
