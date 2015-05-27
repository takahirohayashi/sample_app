require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin" do
    before { visit signin_path }

    # signinに失敗したときのテスト
    describe "with invalid information" do
      before { click_button "Sign in"}

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    # signinに成功したときのテスト
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) } # プロファイルページヘのリンクの表示
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }   # [Sign out] リンクの表示
      it { should_not have_link('Sign in', href: signin_path) } # [Sign in] リンクの非表示

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end

    describe "authorization" do
      describe "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        describe "in the Users controller" do
          describe "visiting the edit page" do
            before { visit edit_user_path(user) }
            it { should have_title('Sign in') }
          end

          describe "submitting to the update action" do
            # Capybaraのvisitメソッドとは異なる、コントローラのアクションへのアクセス手段が導入されています。
            # これは適切なHTTPリクエストを「直接」発行するという方法で、ここではpatchメソッドを使用して
            # PATCHリクエストを発行しています。
            # updateアクション自体をテストするにはリクエストを直接発行する以外に方法がありません
            # (patchメソッドがあることからわかるように、Railsのテストではget、post、deleteメソッドもサポートされています)。
            # これらのメソッドのいずれかを使用してHTTPリクエストを直接発行すると、
            # 低レベルのresponseオブジェクトにアクセスできるようになります。
            # Capybaraのpageオブジェクトと異なり、responseオブジェクトはサーバーの応答自体のテストに使用できます。
            # この場合は、サインインページへのリダイレクトによるupdateアクションの応答を確認します。
            before { patch user_path(user) }
            specify { expect(response).to redirect_to(signin_path) }
          end

          describe "visiting the user index" do
            before { visit users_path }
            it { should have_title('Sign in') }
          end
        end
      end

      describe "as wrong user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user, no_capybara: true }

        describe "submitting a GET request to the Users#edit action" do
          before { get edit_user_path(wrong_user) }
          specify { expect(response.body).not_to match(full_title('Edit user')) }
          specify { expect(response).to redirect_to(root_url) }
        end

        describe "submitting a PATCH request to the Users#update action" do
          before { patch user_path(wrong_user) }
          specify { expect(response).to redirect_to(root_path) }
        end
      end

      describe "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",     with: user.email
            fill_in "Password",  with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do
            it "should render the desired protected page" do
              expect(page).to have_title('Edit user')
            end
          end
        end
      end

      describe "as non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin, no_capybara: true }

        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { expect(response).to redirect_to(root_path) }
        end
      end
    end
  end
end