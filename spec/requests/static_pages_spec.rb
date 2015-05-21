require 'spec_helper'

describe "Static pages" do #RSpec はダブルクォート (") で囲まれた文字列を無視します
  describe "Home ページ" do
    it "'Sample App'という文字が含まれてないといけない" do
      visit '/static_pages/home' #Capybaraのvisit機能を使って、ブラウザでの/static_pages/homeURLへのアクセスをシミュレーションします。
      expect(page).to have_content('Sample App') #Capybaraが提供するpage変数を使って、アクセスした結果のページに正しいコンテンツが表示されているかどうかをテストしています。
    end

    it "'Ruby on Rails Tutorial Sample App' というタイトルを含んでいるか" do
      visit '/static_pages/home'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end

    it "'| Home' というタイトルを含んでいないか" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end
  end

  describe "Help ページ" do
    it "'Help'という文字が含まれてないといけない" do
      visit '/static_pages/help' #Capybaraのvisit機能を使って、ブラウザでの/static_pages/homeURLへのアクセスをシミュレーションします。
      expect(page).to have_content('Help') #Capybaraが提供するpage変数を使って、アクセスした結果のページに正しいコンテンツが表示されているかどうかをテストしています。
    end

    it "'Help' というタイトルが含まれているか？" do
      visit '/static_pages/help'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | Help")
    end
  end

  describe "About ページ" do
    it "'About Us' という文字が含まれていないといけない" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "'About Us' というタイトルを含んでるか？" do
      visit '/static_pages/about'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | About Us")
    end
  end

  describe "Contact ページ" do
    it "'Contact' という文字が含まれていないといけない" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end

    it "'Contact' というタイトルを含んでるか？" do
      visit '/static_pages/contact'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | Contact")
    end
  end

end