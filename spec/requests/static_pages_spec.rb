require 'spec_helper'

describe "Static pagesのテスト" do #RSpec はダブルクォート (") で囲まれた文字列を無視します

  subject { page }

  describe "Home ページのテスト" do
    before { visit root_path }

    it { should have_content('Sample App')}
    it { should have_title(full_title(''))}
    it { should_not have_title('| home')}
  end

  describe "Help ページのテスト" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe "About ページのテスト" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About Us')) }
  end

  describe "Contact ページのテスト" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end

end