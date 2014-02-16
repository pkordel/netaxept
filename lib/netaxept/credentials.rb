require 'forwardable'

module Netaxept
  class Credentials
    extend Forwardable

    def_delegators :@params, :merge, :keys, :[]=

    def initialize(params = {})
      @params              = params
      @params[:merchantId] ||= ENV.fetch 'NETAXEPT_MERCHANT_ID'
      @params[:token]      ||= ENV.fetch 'NETAXEPT_PASSWORD'
    end

    def params
      @params.delete_if { |_k, _v| _v.nil? }
    end
  end
end
