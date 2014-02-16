require 'spec_helper'

module Netaxept
  class QueryRequest < Netaxept::BaseRequest
    def initialize(transaction_id, params = {})
      @params = super(params.merge(Netaxept::Credentials.new.params))
      @params[:transactionId] = transaction_id
    end
  end

  PaymentInfo = Struct.new(:merchant_id, :transaction_id, :query_finished_at)
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

  QueryResponse = Struct.new(:response) do
    def initialize(response)
      @response = Nokogiri::XML response
    end

    def response
      @response
    end

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

    def error
      if err_node = response.xpath("//Error").first
        err_class   = err_node.attr("xsi:type")
        err_message = err_node.xpath("//Message").text
        Object.const_get("#{Netaxept}::#{err_class}").new(err_message)
      end
    end
  end
end

describe 'Check status of a transaction' do
  let(:connection) { establish_connection }
  let(:customer)   { Struct.new(:id,
                                :email,
                                :phone_number,
                                :first_name,
                                :last_name).new(1,
                                                'customer@example.com',
                                                '12345678',
                                                'Peter',
                                                'Pan') }
  let(:order)      { Struct.new(:id,
                                :total,
                                :vat,
                                :description,
                                :customer).new(1,
                                               100,
                                               20,
                                               'DESCRIPTION',
                                               customer) }

  describe 'a valid request' do
    it 'is successful' do
      VCR.use_cassette('register_request_success', record: :new_episodes) do
        request = Netaxept::RegisterRequest.new(order,
                                                customerEmail: customer.email,
                                                customerPhoneNumber: customer.phone_number,
                                                customerNumber: customer.id,
                                                customerFirstName: customer.first_name,
                                                customerLastName: customer.last_name)
        response = parse_response connection.get('/Netaxept/Register.aspx', request.params)
        response.error.must_be_nil
        @transaction_id = response.transaction_id
        @transaction_id.wont_be_nil
      end

      VCR.use_cassette('query_request', record: :new_episodes) do
        request = Netaxept::QueryRequest.new(@transaction_id)
        response = connection.get('/Netaxept/Query.aspx', request.params)
        result = parse_response(response, Netaxept::QueryResponse)

        result.payment_info.merchant_id.wont_be_nil
        result.payment_info.transaction_id.must_equal @transaction_id
        result.payment_info.query_finished_at.wont_be_nil

        result.order_information.order_number.must_equal '1'
        result.order_information.amount.must_equal 100
        result.order_information.currency_code.must_equal 'NOK'
        result.order_information.order_description.must_equal 'DESCRIPTION'
        result.order_information.fee.must_equal 0
        result.order_information.total.must_equal 100
        result.order_information.rounding_amount.must_equal 0
        result.order_information.timestamp.wont_be_nil

        result.authentication_information.eci.must_be_nil

        result.financial_summary.authorization_id.must_be_empty
        result.financial_summary.authorized.must_equal false
        result.financial_summary.annulled.must_equal false
        result.financial_summary.amount_captured.must_equal 0
        result.financial_summary.amount_credited.must_equal 0

        result.customer_information.email.must_equal 'customer@example.com'
        result.customer_information.phone_number.must_equal '12345678'
        result.customer_information.customer_number.must_equal '1'
        result.customer_information.first_name.must_equal 'Peter'
        result.customer_information.last_name.must_equal 'Pan'
      end
    end
  end
end

