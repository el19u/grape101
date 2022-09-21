FactoryBot.define do
  factory :post do
    title { "MyString" }
    context { "MyText" }
    user { nil }
  end
end
