module SingDollar

  class XMLMaker

    attr_reader :caller_object

    def initialize(caller_object)
      @caller_object = caller_object
    end

    def make_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.send(:"singdollar", namespace_schemaloc) do
          xml.send(:"exchange-rates", date: caller_object.date_time) do
            caller_object.each do |currency, exchange_rate|
              xml.send(:"exchange-rate", currency: currency.upcase) do
                xml.send(:"bank-buying") do
                  xml.rate exchange_rate.bank_buying.rate
                end
                xml.send(:"bank-selling") do
                  xml.rate exchange_rate.bank_selling.rate
                end
              end
            end
          end
        end
      end
      builder.to_xml
    end

    private

    def namespace_schemaloc
      {'xmlns'              => 'http://www.cantab-ip.com/singdollar',
       'xmlns:xsi'          => 'http://www.w3.org/2001/XMLSchema-instance',
       'xsi:schemaLocation' => 'http://www.cantab-ip.com/singdollar singdollar.xsd'}
    end
  end
end
