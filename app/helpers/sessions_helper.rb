module SessionsHelper
  def sign_in(user)
    # update_attributeメソッドを使用すれば検証をすり抜けて単一の属性を更新することができます。
    # ページの移動ではユーザーのパスワードやパスワード確認は与えられないので、このメソッドを使用する必要があります。

    # cookiesユーティリティも使用しています。これを使用することで、ブラウザのcookiesをハッシュのように扱うことができます。
    # cookiesの各要素は、それ自体が2つの要素 (valueとオプションのexpires日時) のハッシュになっています。
    # たとえば以下のように、cookiesに20年後に期限切れになる記憶トークンに等しい値を保存することで、ユーザーのサインインを実装できます。
    # cookies[:remember_token] = { value: remember_token, expires: 20.years.from_now.utc }

    remember_token = User.new_remember_token #トークンを新規作成する
    # permanentメソッドによって自動的に期限が20.years.from_nowに設定されます。
    cookies.permanent[:remember_token] = remember_token # 暗号化されていないトークンをブラウザのcookiesに保存する
    user.update_attribute(:remember_token, User.encrypt(remember_token)) # 暗号化したトークンをデータベースに保存する
    self.current_user = user # 与えられたユーザーを現在のユーザーに設定する
  end

  def signed_in?
    !current_user.nil?
  end

  # 要素代入メソッド？？？？
  def current_user=(user)
    @current_user = user
  end

  # remember_tokenを使用して現在のユーザーを検索する。
  def current_user
    remember_token = User.encrypt(cookies[:remember_token]) # cookiesのremember_tokenを暗号化して、remember_tokenに入れる
    # Rubyでは定番の ||= (“or equals”) 代入演算子を使用しています。
    # この代入演算子は、@current_userが未定義の場合にのみ、@current_userインスタンス変数に記憶トークンを設定します。
    # あるユーザーに対してcurrent_userが初めて呼び出される場合はfind_byメソッドを呼び出しますが、
    # 以後の呼び出しではデータベースにアクセスせずに@current_userを返します。
    # このコードは、ひとつのユーザーリクエストに対してcurrent_userが何度も使用される場合にのみ有用です。
    # いずれの場合も、ユーザーがWebサイトにアクセスするとfind_byは最低1回は呼び出されます。
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    # このコードは、値がnilでなければsession[:return_to]を評価し、nilであれば与えられたデフォルトのURLを使用します
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  # url (ここではリクエストされたページのURL) の取得にはrequestオブジェクトを使用しています。
  # リクエストされたURLを:return_toというキーでsession変数に保存しています。
  def store_location
    session[:return_to] = request.url
  end

end
