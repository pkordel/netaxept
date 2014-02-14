require 'unit_spec_helper'
require 'netaxept/register_request'

describe Netaxept::RegisterRequest do

  let(:order) { Struct.new(:id, :total, :vat).new(1, 100, 20) }

  subject { Netaxept::RegisterRequest.new(order) }

  describe 'attributes' do
    it 'responds to required attributes' do
      subject.must_respond_to :orderNumber
      subject.must_respond_to :orderDescription
      subject.must_respond_to :serviceType
      subject.must_respond_to :currencyCode
      subject.must_respond_to :amount
      subject.must_respond_to :force3DSecure
      subject.must_respond_to :updateStoredPaymentInfo
      subject.must_respond_to :language
      subject.must_respond_to :redirectUrl
      subject.must_respond_to :terminalVat
      subject.must_respond_to :customerNumber
      subject.must_respond_to :customerEmail
      subject.must_respond_to :customerPhoneNumber
      subject.must_respond_to :customerFirstName
      subject.must_respond_to :customerLastName
      subject.must_respond_to :recurringType
      subject.must_respond_to :recurringFrequency
      subject.must_respond_to :recurringExpiryDate
      subject.must_respond_to :panHash
    end
  end

  describe '.merge' do
    it 'merges successfully' do
      expected = [:foo]
      (subject.merge(foo: 'bar').keys & expected).must_equal expected
    end

    it 'merges with wrong type' do
      expected = subject.attributes.keys
      subject.merge('wrong').keys.must_equal expected
      subject.merge(nil).keys.must_equal expected
      subject.merge('').keys.must_equal expected
      subject.merge.keys.must_equal expected
    end
  end

  describe 'defaults and values' do
    it 'provides default values' do
      subject.orderNumber.must_equal 1
      subject.amount.must_equal 100
    end

    it 'pulls in environment vars' do
      ENV["NETAXEPT_REDIRECT_URL"]  ||= "http://localhost:3000/complete_order"
      subject.redirectUrl.wont_be_nil
    end

    it 'formats attributes' do
      expected = [:orderNumber, :amount, :terminalVat]
      (subject.attributes.keys & expected).must_equal expected
    end
  end

end
