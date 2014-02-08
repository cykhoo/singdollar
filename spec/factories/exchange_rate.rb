FactoryGirl.define do
  factory :exchange_rate, aliases: [:usd_exchange_rate], class: SingDollar::ExchangeRate do
    bank_buying  :usd_buying
    bank_selling :usd_selling

    factory :eur_exchange_rate do
      bank_buying  :eur_buying
      bank_selling :eur_selling
    end
  end
end
