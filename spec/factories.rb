FactoryBot.define do
  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
    admin { true }
    active { true }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
    active { true }
  end

  factory :style do
    name { "anonymous" }
  end

  factory :beer do
    name { "anonymous" }
    style
    brewery # the brewery associated with beer is created with brewery factory
  end

  factory :rating do
    score { 10 }
    beer # The beer associated with rating is created with beer factory
    user # The user associated with rating is created with user factory
  end
end