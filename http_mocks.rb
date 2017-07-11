require 'sinatra'
require 'json'
require 'xmlsimple'
require 'pry'

# [status (Fixnum), headers (Hash), response body (responds to #each)]
get '/request' do
	resp_content_type = params['content_type'] || 'json'
	resp_timeout = params['timeout'].to_f || 0.0
	resp_status = params['status'].to_i || 200
	resp_headers = params['headers'] || '{}'
	body = { :key1 => 'value1', :key2 => 'value2' }

	resp_headers = RequestHelp.validate_headers(resp_headers)
  case resp_content_type
  	when 'json'
  	  resp_content_type = 'application/json'  
  		body = body.to_json
  	when 'xml'
  		resp_content_type = 'text/xml'
  		body = XmlSimple.xml_out(body)
  end
  
  content_type resp_content_type
  sleep resp_timeout

	[resp_status, resp_headers, body]
end

class RequestHelp
	def self.validate_headers(headers_hash)
		return_hash = {}
		if headers_hash
			JSON.parse(headers_hash)
		end
	rescue => e
		binding.pry
		puts "HEADER VALUE NOT VALID"
		raise "invalid header"
	end 
end