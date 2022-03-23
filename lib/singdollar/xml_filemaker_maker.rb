module SingDollar

  class FileMakerXMLMaker

    attr_reader :caller_object

    def initialize(caller_object)
      @caller_object = caller_object
    end

    def make_fmpxml
      metadata_fields = ["ISO 4217 Code", "TEXT",
                         "Rate Bank Buying", "NUMBER",
                         "Rate Bank Selling", "NUMBER",
                         "Rate Updated TimeStamp", "TIMESTAMP"]
      date_time = convert_to_filemaker_datestamp(caller_object.date_time)
      builder = generate_metadata(metadata_fields) do |xml|
        xml.RESULTSET(FOUND: caller_object.length) do
          caller_object.each do |currency, exchange_rate|
            xml.ROW(MODID: "0", RECORDID: "0") do
              [currency.upcase,
               exchange_rate.bank_buying.rate,
               date_time].each do |value|
                # value = value.to_slash_format if value.instance_of?(Time)
                xml.COL do
                  xml.DATA value
                end
              end
            end
          end
        end
      end
      builder.to_xml
    end

    def headers(&block)
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.FMPXMLRESULT(xmlns:"http://www.filemaker.com/fmpxmlresult") do
          xml.ERRORCODE 0
          xml.PRODUCT(BUILD: "03-21-2013", NAME: "FileMaker", VERSION: "ProAdvanced 12.0v4")
          xml.DATABASE(DATEFORMAT: "D/m/yyyy", LAYOUT: "", NAME: "Granta.fmp12", RECORDS: 1, TIMEFORMAT: "h:mm:ss a")
          yield(xml) if block_given?
        end
      end
    end

    private

    def generate_metadata(metadata_fields, &block)
      builder = headers do |xml|
        xml.METADATA do
          metadata_fields.each_slice(2) do |value_type|
            xml.FIELD(EMPTYOK: "YES", MAXREPEAT: "1", NAME: value_type[0], TYPE: value_type[1])
          end
        end
        yield(xml) if block_given?
      end
    end

    def convert_to_filemaker_datestamp(date_time)
      date_time.getlocal.strftime("%-d/%-m/%Y %l:%M %p")
    end
  end
end
