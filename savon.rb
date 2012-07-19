require 'savon'
require 'pry'

real_host = 'kim-cm-bts01.scc.kit.edu'; real_port = 80
alias_host = 'localhost'; alias_port = 8765
url = 'http://%s:%d/HeadingTreeService/HeadingTreeService.svc?wsdl' % [alias_host, alias_port]

Savon.configure do |c|
  # the URLs in the WSDL point to the original host. We need to rewrite those
  # to localhost
  c.hooks.define('rewrite_host', :soap_request) do |req|
    req.http.url.host = alias_host
    req.http.url.port = alias_port
    binding.pry
    nil
  end
end

client = Savon::Client.new(url) do
  # we need to send the correct Host header on every request. This is kind of
  # a hack, because we set the header globally. We only forward one port, so
  # this should be fine for now.
  http.headers = { 'Host' => "%s:%d" % [real_host, real_port]  }
end

# make a request
client.request "GetHeadingTreeReq" do
  term = "SS 2012"
  # we should make IIS understand what Savon generates, instead of hardcoding
  # the envelope!
  soap.xml = <<-XML
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:kit="http://KIT.Campus.Migration.KIM.Service.EventService.GetHeadingTree">
          <soapenv:Header/>
          <soapenv:Body>
            <kit:GetHeadingTreeReq>
                <!--1 or more repetitions:-->
                <Semester>#{term}</Semester>
            </kit:GetHeadingTreeReq>
          </soapenv:Body>
     </soapenv:Envelope>
  XML
end
