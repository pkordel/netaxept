module Netaxept
  class QueryRequest < Netaxept::BaseRequest

    def initialize(transaction_id, params = {})
      params = Netaxept::Credentials.new.params.merge(params)
      @params = super(params)
      @params[:transactionId] = transaction_id
    end
  end
end
