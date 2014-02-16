require 'unit_spec_helper'

describe Netaxept::BaseResponse do
  let(:fragment) do
    <<-XML
    <Error xsi:type=\"AuthenticationException\">\r\n
            \   <Message>Test: Unable to authenticate merchant (credentials not passed)</Message>\r\n
            \ </Error>
    XML
  end
  subject { Netaxept::BaseResponse.new(fragment) }

  describe '.error' do
    it 'responds to error' do
      subject.error.must_be_instance_of Netaxept::AuthenticationException
    end
  end

end
