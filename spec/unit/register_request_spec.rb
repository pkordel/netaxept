require 'unit_spec_helper'

describe Netaxept::RegisterRequest do

  let(:order) { Struct.new(:id, :total, :vat, :description).new(1, 100, 20, 'DESCRIPTION') }

  subject { Netaxept::RegisterRequest.new(order) }

  describe '.merge' do
    it 'merges successfully' do
      expected = [:foo]
      (subject.merge(foo: 'bar').keys & expected).must_equal expected
    end
  end

  describe 'defaults and values' do
    it 'provides default values' do
      subject[:orderNumber].must_equal 1
      subject[:amount].must_equal 100
      subject[:currencyCode].must_equal 'NOK'
    end

    it 'pulls in environment vars' do
      ENV["NETAXEPT_REDIRECT_URL"]  ||= "http://localhost:3000/complete_order"
      subject[:redirectUrl].wont_be_nil
    end

    it 'formats attributes' do
      expected = [:orderNumber, :amount, :terminalVat]
      (subject.keys & expected).must_equal expected
    end
  end

end
