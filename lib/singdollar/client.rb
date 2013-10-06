require 'open-uri'
require 'net/http'

module SingDollar

  class Client

    USER_AGENT_STRING = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"

    def get_url(url, encoding = 'UTF-8')
      open(url, "User-Agent" => USER_AGENT_STRING).read.encode('UTF-8', encoding)
    end

    def post_url(url, form_data)
      uri                     = URI.parse(url)
      http                    = Net::HTTP.new(uri.host, uri.port)
      request                 = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "text/html"
      request.set_form_data(form_data)
      response                = http.request(request)
      response.body
    end
  end
end
