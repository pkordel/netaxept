# coding: utf-8
require 'dotenv'
require 'nokogiri'

require 'netaxept/version'
require 'netaxept/base_request'
require 'netaxept/base_response'
require 'netaxept/register_request'
require 'netaxept/register_response'
require 'netaxept/query_request'
require 'netaxept/query_response'
require 'netaxept/credentials'
require 'netaxept/exceptions'

module Netaxept
  Dotenv.load
end
