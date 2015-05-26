require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid } # 単なる健全性チェックです。これを使用して、まず@userというsubjectが有効かどうかを確認します。

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid } #should_not @user.name = " "の時は、健全ではないことをチェックする。
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid } #should_not @user.name = " "の時は、健全ではないことをチェックする。
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid } #should_not @user.name = "a"*51の時は、健全ではないことをチェックする
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com] # 文字列配列を作成
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid #not_to be_valid 上記配列の時は、健全ではないことをチェックする
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid # 上記配列の場合は、健全であることをチェックする
      end
    end
  end

  describe "when email address is already taken" do # 一意制約チェック
    before do
      user_with_same_email = @user.dup # dupメソッドでオブジェクトのコピーを作る
      user_with_same_email.email = @user.email.upcase # emailを大文字にして上書き
      user_with_same_email.save
    end

    it { should_not be_valid } # 健全でないことを確認する
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ") # passwordとpassword_confirmationを" "にして、上書き
    end
    it { should_not be_valid } # 健全でないことを確認する
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" } # password_confirmation = "mismatch"を代入。 password != password_confirmation　の場合のテスト
    it { should_not be_valid } # 健全でないことを確認する
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 } # 5文字をpasswordとpassword_confirmationに入れる
    it { should be_invalid } # be_invalid 健全でないことを確認する
  end

  # 林オリジナルテスト
  describe "6文字はOKなことを確認するテスト" do
    before { @user.password = @user.password_confirmation = "a" * 6 } # 6文字をpasswordとpassword_confirmationに入れる
    it { should be_valid } # 健全なことを確認する
  end

  # ユーザー認証のテスト
  describe "return value of authenticate method" do
    before { @user.save } # 事前にユーザーをDBに保存する
    let(:found_user) { User.find_by(email: @user.email) } # 上で保存したユーザーをemailをkeyにfind_byでselectして、:found_userに格納する。

    describe "with valid password" do
      # it(=@user)がfound_userに@user.passwordで
      # authenticateメソッドを呼んで、@user.passwordが:found_userのパスワードと一致したら、
      # found_userを返すから、@saveとfound_userは同じであることを確認する
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      # "invalid"というパスワードの場合は、authenticateメソッドは認証失敗でfalseを返すから
      # :user_for_invalid_passwordの中身はfalseになる。
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      # it(=@user)はuser_for_invalid_password(=false)は一致しないことを確認
      it { should_not eq user_for_invalid_password }
      # user_for_invalid_passwordはfalseであることを確認 specifyは主語が変なときに使うだけ。itと意味は変わらない
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  # 記憶トークンのテスト
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank } # its @userの:remember_token が ブランクじゃないこと
    # it { expect(@user.remember_token).not_to be_blank } 上記と同じ
  end

end