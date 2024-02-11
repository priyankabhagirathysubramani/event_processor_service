FactoryBot.define do
  factory :subscription do
    stripe_id { "sub_#{SecureRandom.hex(14)}" }
    state { 0 }
  end
end