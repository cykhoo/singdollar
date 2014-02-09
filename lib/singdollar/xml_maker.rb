module SingDollar

  class XMLMaker

    attr_reader :caller_object

    def initialize(caller_object)
      @caller_object = caller_object
    end

    def make_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.send(:"singdollar", namespace_schemaloc) do
          "5"
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
