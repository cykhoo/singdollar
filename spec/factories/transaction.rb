FactoryBot.define do
  factory :transaction_usd_buying, aliases: [:transaction], class: SingDollar::Transaction do
    currency { :usd }
    type     { :bank_buying }
    rate     { 1.2592 }
  end

  factory :transaction_usd_selling, class: SingDollar::Transaction do
    currency { :usd }
    type     { :bank_selling }
    rate     { 1.2787 }
  end

  factory :transaction_eur_buying, class: SingDollar::Transaction do
    currency { :eur }
    type     { :bank_buying }
    rate     { 1.7250 }
  end

  factory :transaction_eur_selling, class: SingDollar::Transaction do
    currency { :eur }
    type     { :bank_selling }
    rate     { 1.7480 }
  end
end
