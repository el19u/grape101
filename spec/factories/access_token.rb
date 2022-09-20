FactoryBot.define do
  factory :api_access_tokens do
    association :user, factory: [:user]
    key { SecureRandom.uuid.delete("-") }
    
  end
end