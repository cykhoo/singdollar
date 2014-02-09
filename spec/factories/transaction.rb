FactoryGirl.define do
  factory :transaction_usd_buying, aliases: [:transaction], class: SingDollar::Transaction do
    currency :usd
    type     :bank_buying
    tt       1.2592
    od       1.2542
  end

  factory :transaction_usd_selling, class: SingDollar::Transaction do
    currency :usd
    type     :bank_selling
    tt       1.2787
    od       1.2788
  end

  factory :transaction_eur_buying, class: SingDollar::Transaction do
    currency :eur
    type     :bank_buying
    tt       1.2592
    od       1.2542
  end

  factory :transaction_eur_selling, class: SingDollar::Transaction do
    currency :eur
    type     :bank_selling
    tt       1.7480
    od       1.7480
  end
end
