require 'spec_helper'

describe "Static pagesのテスト" do #RSpec はダブルクォート (") で囲まれた文字列を無視します

  subject { page }

  describe "Home ページのテスト" do
    before { visit root_path }

    it { should have_content('Sample App')}
    it { should have_title(full_title(''))}
    it { should_not have_title('| home')}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          # (li##{item.id}の最初の# は CSS idを示す Capybara独自の文法で、
          # 2番目の#は Rubyの式展開#{}の先頭部分であることに注意してください)。
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
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