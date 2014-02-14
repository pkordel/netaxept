module Netaxept
  class RegisterRequest < Struct.new( :orderNumber,
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
                                      :panHash )

    def initialize(order)
      send "redirectUrl=",    ENV.fetch("NETAXEPT_REDIRECT_URL")
      send "orderNumber=",    order.id
      send "amount=",         order.total
      send "terminalVat=",    order.vat
    end

    def attributes
      attributes = self.to_h.dup
      attributes.delete_if { |_k, v| v.nil? }
    end

    def merge(other_hash = {})
      if other_hash.respond_to? :to_h
        attributes.merge(other_hash.to_h)
      else
        attributes
      end
    end
  end
end
