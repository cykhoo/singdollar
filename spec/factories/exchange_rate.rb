FactoryGirl.define do
  factory :exchange_rate, aliases: [:usd_exchange_rate], class: SingDollar::ExchangeRate do
    bank_buying  { FactoryGirl.build(:transaction_usd_buying) }
    bank_selling { FactoryGirl.build(:transaction_usd_selling) }

    factory :eur_exchange_rate do
      bank_buying  { FactoryGirl.build(:transaction_eur_buying) }
      bank_selling { FactoryGirl.build(:transaction_eur_selling) }
    end
  end
end
