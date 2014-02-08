FactoryGirl.define do
  factory :transaction, aliases: [:usd_buying], class: SingDollar::Transaction do
    currency :usd
    type     :bank_buying
    tt       1.2592
    od       1.2542

    factory :usd_selling do
      type     :bank_selling
      tt       1.2787
      od       1.2788
    end

    factory :eur_buying do
      currency :eur
      type     :bank_buying
      tt       1.2592
      od       1.2542

      factory :eur_selling do
        type     :bank_selling
        tt       1.7480
        od       1.7480
      end
    end
  end
end
