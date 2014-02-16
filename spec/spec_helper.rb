# coding: utf-8
require 'unit_spec_helper'
require 'faraday'
require 'vcr_setup'

def parse_response(response, response_class = Netaxept::RegisterResponse)
  response_class.new response.body
end

def establish_connection
  Faraday.new(url: ENV["NETAXEPT_URL"]) do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end
end
