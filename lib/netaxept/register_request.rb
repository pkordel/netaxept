module Netaxept
  class RegisterRequest < BaseRequest

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

    def initialize(order, params = {})
      params = Netaxept::Credentials.new(params).params
      @params                     = super(params)
      @params[:redirectUrl]       ||= ENV.fetch("NETAXEPT_REDIRECT_URL")
      @params[:orderNumber]       ||= order.id
      @params[:amount]            ||= order.total
      @params[:terminalVat]       ||= order.vat
      @params[:orderDescription]  ||= order.description
      @params[:currencyCode]      = 'NOK'
      @params[:recurringType]     = 'S'
    end

    def params
      @params.delete_if { |_k, _v| _v.nil? }
    end
  end
end
