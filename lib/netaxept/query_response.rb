module Netaxept

  PaymentInfo = Struct.new(:merchant_id,
                           :transaction_id,
                           :query_finished_at)

  OrderInformation = Struct.new(:order_number,
                                :amount,
                                :currency_code,
                                :order_description,
                                :fee,
                                :total,
                                :rounding_amount,
                                :timestamp)

  AuthenticationInformation = Struct.new(:eci)

  FinancialSummary = Struct.new(:authorization_id,
                                :authorized,
                                :annulled,
                                :amount_captured,
                                :amount_credited)

  CustomerInformation = Struct.new(:email,
                                   :phone_number,
                                   :customer_number,
                                   :first_name,
                                   :last_name)

  class QueryResponse < BaseResponse

    def customer_information
      root            = response.xpath("//CustomerInformation")
      email           = root.xpath("Email").text
      phone_number    = root.xpath("PhoneNumber").text
      customer_number = root.xpath("CustomerNumber").text
      first_name      = root.xpath("FirstName").text
      last_name       = root.xpath("LastName").text
      CustomerInformation.new(email,
                              phone_number,
                              customer_number,
                              first_name,
                              last_name)
    end

    def payment_info
      root              = response.xpath("//PaymentInfo")
      merchant_id       = root.xpath("MerchantId").text
      transaction_id    = root.xpath("TransactionId").text
      query_finished_at = root.xpath("QueryFinished").text
      PaymentInfo.new(merchant_id, transaction_id, query_finished_at)
    end

    def order_information
      root              = response.xpath("//OrderInformation")
      order_number      = root.xpath("OrderNumber").text
      amount            = root.xpath("Amount").text.to_i
      currency_code     = root.xpath("Currency").text
      order_description = root.xpath("OrderDescription").text
      fee               = root.xpath("Fee").text.to_i
      total             = root.xpath("Total").text.to_i
      rounding_amount   = root.xpath("RoundingAmount").text.to_i
      timestamp         = root.xpath("Timestamp").text
      OrderInformation.new(order_number,
                           amount,
                           currency_code,
                           order_description,
                           fee,
                           total,
                           rounding_amount,
                           timestamp)
    end

    def authentication_information
      root = response.xpath("//AuthenticationInformation")
      AuthenticationInformation.new
    end

    def financial_summary
      root = response.xpath("//Summary")
      authorization_id  = root.xpath("AuthorizationId").text
      authorized        = (root.xpath("Authorized").text == "true")
      annulled          = (root.xpath("Annulled").text == "true")
      amount_captured   = root.xpath("AmountCaptured").text.to_i
      amount_credited   = root.xpath("AmountCredited").text.to_i
      FinancialSummary.new(authorization_id,
                           authorized,
                           annulled,
                           amount_captured,
                           amount_credited)
    end
  end
end
