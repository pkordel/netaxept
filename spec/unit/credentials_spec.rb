require 'unit_spec_helper'

describe Netaxept::Credentials do
  subject { Netaxept::Credentials.new }

  it 'acts as a hash' do
    subject.keys.must_equal [:merchantId, :token]
  end

  it 'merges another hash' do
    subject.merge({foo: 'bar'}).keys.must_equal [:merchantId, :token, :foo]
    subject.merge({foo: 'bar'})[:foo].must_equal 'bar'
  end
end
