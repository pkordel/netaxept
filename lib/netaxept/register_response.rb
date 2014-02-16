module Netaxept
  class RegisterResponse < BaseResponse
    def transaction_id
      response.xpath("//TransactionId").text
    end
  end
end
