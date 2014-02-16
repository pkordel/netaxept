require 'forwardable'

module Netaxept
  class RegisterRequest
  extend Forwardable

  VALID_KEYS = [:orderNumber,
                :orderDescription,
                :serviceType,
                :description,
                :currencyCode,
                :amount,
                :terminalVat,
                :force3DSecure,
                :updateStoredPaymentInfo,
                :redirectUrl,
                :language,
                :customerNumber,
                :customerEmail,
                :customerPhoneNumber,
                :customerFirstName,
                :customerLastName,
                :recurringType,
                :recurringFrequency,
                :recurringExpiryDate,
                :panHash]

    def_delegators :@params, :merge, :[], :keys

    def initialize(order, params = {})
      @params                     = params
      @params[:redirectUrl]       = ENV.fetch("NETAXEPT_REDIRECT_URL")
      @params[:orderNumber]       = order.id
      @params[:amount]            = order.total
      @params[:terminalVat]       = order.vat
      @params[:orderDescription]  = order.description
      @params[:currencyCode]      = 'NOK'
      @params[:recurringType]     = 'S'
    end

    def params
      @params.delete_if { |_k, _v| _v.nil? }
    end
  end
end
