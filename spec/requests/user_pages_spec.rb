require 'spec_helper'

describe "User pagesのテスト" do

  subject { page }

  describe "signup pageのテスト" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end
end