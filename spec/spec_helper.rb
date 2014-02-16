# coding: utf-8
require 'unit_spec_helper'
require 'netaxept'
require 'faraday'
require 'debugger'
require 'vcr_setup'

def parse_response response
  Netaxept::RegisterResponse.new response.body
end

def establish_connection
  Faraday.new(url: ENV["NETAXEPT_URL"]) do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end
end
