FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  # これによって、以下のようにマイクロポスト用のファクトリーを定義できるようになります。
  # FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
  # Factory Girlを使用すると、Active Recordがアクセスを許可しないような
  # created_at属性も手動で設定できるので大変便利です
  factory :micropost do
    content "Lorem ipsum"
    # マイクロポスト用のファクトリーの定義にuserを含めるだけで、
    # マイクロポストに関連付けられるユーザーのことがFactory Girlに伝わります。
    user
  end

end