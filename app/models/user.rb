class User < ActiveRecord::Base
  # コールバックとは、Active Recordオブジェクトが持続している間のどこかの時点で、
  # Active Recordオブジェクトに呼び出してもらうメソッドです
  # 今回の場合は、before_saveコールバックを使います。
  # ユーザーをデータベースに保存する前にemail属性を強制的に小文字に変換します。
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 } # 必須入力/50文字制限
#  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # 正規表現を使ったメールアドレスフォーマットの検証
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i #（ドットが２つ以上連続するかどうか）を検証する正規表現

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } # case_sensitiveオプションにfalseを指定することで、大文字小文字の差を無視する
  has_secure_password # これが強力なやつ
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
