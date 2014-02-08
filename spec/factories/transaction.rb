FactoryGirl.define do
  factory :transaction, class: SingDollar::Transaction do
    currency :usd
    type     :bank_buying
    tt       1.2592
    od       1.2542
  end
end
