FactoryGirl.define do
  factory :exchange_rate, class: SingDollar::ExchangeRate do
    currency     :usd
    transactions [:transaction, :transaction]
  end
end
