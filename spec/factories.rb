FactoryGirl.define do
  factory :user do
    name     "Takahiro Hayashi"
    email    "takahiro.hayashi@mossgreen.co.jp"
    password "foobar"
    password_confirmation "foobar"
  end
end