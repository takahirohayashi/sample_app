class User < ActiveRecord::Base
  # ユーザー自体が破棄されたときに、そのユーザーに依存するマイクロポストも
  # 破棄されることを指定しています。
  # これは、管理者がシステムからユーザーを削除したときに、
  # 依存するユーザーが存在しないマイクロポストがデータベースに取り残されてしまうことを防ぎます。
  has_many :microposts, dependent: :destroy
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
  validates :password_confirmation, presence: true

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # user_idが現在のユーザーidと等しいマイクロポストを見つけることによって、
    # 適切なマイクロポストのfeedメソッドを実装することができます。
    # これはMicropostモデルでwhereメソッドを使用することで実現できます。
    # 疑問符があることで、SQLクエリにインクルードされる前にidが適切にエスケープされることを
    # 保証してくれるため、SQLインジェクションと呼ばれる深刻なセキュリティホールを避けることができます。
    # この場合のid属性は単なる整数であるため危険はありませんが、
    # SQL文にインクルードされる変数を常にエスケープする習慣はぜひ身につけてください。
    Micropost.where("user_id = ?", id)
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
