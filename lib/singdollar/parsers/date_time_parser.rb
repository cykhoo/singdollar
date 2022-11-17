module SingDollar

  class DateTimeParser

    attr_reader :page

    def initialize(page)
      @page = page
    end

    def parse_date_time
      date_node = page.xpath("//*[@id='ocbc-fx-calculator-last-update-time']/text()")
      date_time = make_date_time(date_node)
      date_time
    end

    private

    def make_date_time(date_node)
      puts "Generating timestamp..."
      date_time_text = date_text + " " + time_text
      date_time = Time.parse(date_time_text)
      date_time
    end

    def date_text
      puts "Searching for date page was updated..."
      page.xpath("//*[@id='ocbc-fx-calculator-last-update-date']/text()").text
    end

    def time_text
      puts "Searching for time page was updated..."
      page.xpath("//*[@id='ocbc-fx-calculator-last-update-time']/text()").text
    end

  end
end
