module Netaxept
  class RegisterRequest < Struct.new( :merchantId,              :token,
                                      :orderNumber,             :serviceType,
                                      :description,             :currencyCode,
                                      :amount,                  :force3DSecure,
                                      :updateStoredPaymentInfo, :redirectUrl,
                                      :terminalVat,             :orderDescription,
                                      :language,                :customerNumber,
                                      :customerEmail,           :customerPhoneNumber,
                                      :customerFirstName,       :customerLastName,
                                      :recurringType,           :recurringFrequency,
                                      :recurringExpiryDate,     :panHash )

    def initialize(order)
      send "merchantId=",     ENV["NETAXEPT_MERCHANT_ID"]
      send "token=",          ENV["NETAXEPT_PASSWORD"]
      send "redirectUrl=",    ENV["NETAXEPT_REDIRECT_URL"]
      send "orderNumber=",    order.id
      send "amount=",         order.total
      send "terminalVat=",    order.vat
    end

    def attributes
      attributes = self.to_h.dup
      # attributes.delete_if { |_k, v| v.blank? }
      attributes.delete_if { |_k, v| v.nil? }
    end
  end
end
