FactoryBot.define do
  email { Faker::Internet.email }
  password { "a00000000" }
  password_confirmation { "a00000000" }
  # password { Faker::Internet.password }
  # password_confirmation { password }
end