module SingDollar

  require 'mechanize'
  require 'nokogiri'

  class ExchangeRatesMaker

    def create
      usd[4].text.strip.to_f
    end

    def agent
      @agent || Mechanize.new
    end

    def page
      @page || agent.get('http://www.ocbc.com/rates/daily_price_fx.html')
    end

    def html
      page.body
    end

    def doc
      @doc ||= Nokogiri::HTML(html)
    end

    def usd
      # doc.xpath('//p[@class="header"]/a[@name="SGD"]')
      # doc.xpath('//table[@class="MsoNormalTable"][2]')
      doc.xpath("//table/tr/td//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[@style='mso-yfti-irow:2']/td")
    end
  end
end
