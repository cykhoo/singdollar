module SingDollar

  class FileMakerXMLMaker

    attr_reader :caller_object

    def initialize(caller_object)
      @caller_object = caller_object
    end

    def make_fmpxml
      '<?xml version="1.0" encoding="UTF-8"?>'
    end
  end
end
