require 'unit_spec_helper'

describe Netaxept::BaseRequest do

  subject { Netaxept::BaseRequest.new }

  describe '.merge' do
    it 'merges successfully' do
      expected = [:foo]
      (subject.merge(foo: 'bar').keys & expected).must_equal expected
    end
  end

end
