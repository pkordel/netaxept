require 'spec_helper'

describe 'Register payment' do
  let(:connection) { establish_connection }
  let(:order)      { Struct.new(:id, :total, :vat, :description).new(1, 100, 20, 'DESCRIPTION') }

  describe 'a valid request' do
    it 'is successful' do
      VCR.use_cassette('register_request_success', record: :new_episodes) do
        request = Netaxept::RegisterRequest.new(order)
        response = parse_response connection.get('/Netaxept/Register.aspx', request.params)
        response.error.must_be_nil
        response.transaction_id.wont_be_nil
      end
    end
  end

  describe 'when missing credentials' do
    it 'returns error' do
      VCR.use_cassette('register_request_missing_credentials', record: :new_episodes) do
        request = Netaxept::RegisterRequest.new(order)
        request.params.delete(:merchantId)
        response = parse_response connection.get('/Netaxept/Register.aspx', request.params)
        error = response.error
        error.must_be_instance_of Netaxept::AuthenticationException
        error.message.must_equal "Test: Unable to authenticate merchant (credentials not passed)"
      end
    end
  end

  describe 'when missing order number' do
    it 'returns error' do
      VCR.use_cassette('register_request_missing_order_number', record: :new_episodes) do
        request = Netaxept::RegisterRequest.new(order)
        request.params.delete(:orderNumber)
        response = parse_response connection.get('/Netaxept/Register.aspx', request.params)
        error = response.error
        error.must_be_instance_of Netaxept::ValidationException
        error.message.must_equal "Missing parameter: 'Order Number'"
      end
    end
  end

  describe 'when missing order amount' do
    it 'returns error' do
      VCR.use_cassette('register_request_missing_order_amount', record: :new_episodes) do
        request = Netaxept::RegisterRequest.new(order)
        request.params.delete(:amount)
        response = parse_response connection.get('/Netaxept/Register.aspx', request.params)
        error = response.error
        error.must_be_instance_of Netaxept::ValidationException
        error.message.must_equal "Missing parameter: 'Amount'"
      end
    end
  end

  describe 'when missing currency code' do
    it 'returns error' do
      VCR.use_cassette('register_request_missing_currency_code', record: :new_episodes) do
        request = Netaxept::RegisterRequest.new(order)
        request.params.delete(:currencyCode)
        response = parse_response connection.get('/Netaxept/Register.aspx', request.params)
        error = response.error
        error.must_be_instance_of Netaxept::ValidationException
        error.message.must_equal "Missing parameter: 'Currency Code'"
      end
    end
  end
end

