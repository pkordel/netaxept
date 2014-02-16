require 'forwardable'

module Netaxept
  class BaseRequest
  extend Forwardable

    def_delegators :@params, :merge, :[], :keys

    def initialize(params = {})
      @params = params
    end

    def params
      @params.delete_if { |_k, _v| _v.nil? }
    end
  end
end
