FactoryGirl.define do
  factory :exchange_rate, aliases: [:usd_exchange_rate], class: SingDollar::ExchangeRate do
    currency     :usd
    transactions [:usd_buying, :usd_selling]

    factory :eur_exchange_rate do
      currency     :eur
      transactions [:eur_buying, :eur_selling]
    end
  end
end
