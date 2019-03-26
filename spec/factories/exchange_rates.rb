FactoryBot.define do
  factory :exchange_rates, class: SingDollar::ExchangeRates do
    date_time { Time.now }
  end
end
