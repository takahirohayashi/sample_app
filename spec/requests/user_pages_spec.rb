require 'spec_helper'

describe "User pagesのテスト" do

  subject { page } # page＝it

  describe "profile pageのテスト" do
    let(:user) { FactoryGirl.create(:user) } # Factory Girlで userを作成して、:userに入れる
    # :userデータでuser pageに行く。
    # page；レスポンスがHTMLである場合、その内容を本メソッドで取得できる。これはCapybaraの機能のひとつ。
    before { visit user_path(user) }

    it { should have_content(user.name) } # pageのコンテントはuser.nameを持っていることを確認
    it { should have_title(user.name) } # pageはタイトルにuser.nameを持っていることを確認
  end

  describe "signup pageのテスト" do
    before { visit signup_path } # signup pageに行ってその内容が page(=it) に入る。

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    let(:submit) { "Create my account" } # :submit = "Create my account"

    # 未入力のテストケース
    describe "with invalid information" do
      it "should not create a user" do
        # not_to ボタン押下前後で User.countに変化が無いことを確認する
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    # 入力時のテストケース
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        # to ボタン押下前後で User.countが1つ増えることを確認する
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success'), text: 'Welcome' }
      end
    end

  end

end