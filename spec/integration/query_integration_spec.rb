require 'spec_helper'

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
  let(:transaction_id) do
    VCR.use_cassette('register_request_success', record: :new_episodes) do
      request = Netaxept::RegisterRequest.new(order,
                                              customerEmail:        customer.email,
                                              customerPhoneNumber:  customer.phone_number,
                                              customerNumber:       customer.id,
                                              customerFirstName:    customer.first_name,
                                              customerLastName:     customer.last_name)
      response  = connection.get('/Netaxept/Register.aspx', request.params)
      result    = parse_response(response, Netaxept::RegisterResponse)
      result.transaction_id
    end
  end



  describe 'a valid request' do

    it 'parses response' do
      query_response = VCR.use_cassette('query_request', record: :new_episodes) do
        request   = Netaxept::QueryRequest.new(transaction_id)
        response  = connection.get('/Netaxept/Query.aspx', request.params)
        parse_response(response, Netaxept::QueryResponse)
      end

      query_response.payment_info.merchant_id.wont_be_nil
      query_response.payment_info.transaction_id.must_equal transaction_id
      query_response.payment_info.query_finished_at.wont_be_nil

      query_response.order_information.order_number.must_equal '1'
      query_response.order_information.amount.must_equal 100
      query_response.order_information.currency_code.must_equal 'NOK'
      query_response.order_information.order_description.must_equal 'DESCRIPTION'
      query_response.order_information.fee.must_equal 0
      query_response.order_information.total.must_equal 100
      query_response.order_information.rounding_amount.must_equal 0
      query_response.order_information.timestamp.wont_be_nil

      query_response.authentication_information.eci.must_be_nil

      query_response.financial_summary.authorization_id.must_be_empty
      query_response.financial_summary.authorized.must_equal false
      query_response.financial_summary.annulled.must_equal false
      query_response.financial_summary.amount_captured.must_equal 0
      query_response.financial_summary.amount_credited.must_equal 0

      query_response.customer_information.email.must_equal 'customer@example.com'
      query_response.customer_information.phone_number.must_equal '12345678'
      query_response.customer_information.customer_number.must_equal '1'
      query_response.customer_information.first_name.must_equal 'Peter'
      query_response.customer_information.last_name.must_equal 'Pan'
    end
  end
end

