module Netaxept
  class RegisterResponse
    attr_reader :response

    def initialize(response)
      @response = Nokogiri::XML response
    end

    def error
      if err_node = response.xpath("//Error").first
        err_class   = err_node.attr("xsi:type")
        err_message = err_node.xpath("//Message").text
        Object.const_get("#{Netaxept}::#{err_class}").new(err_message)
      end
    end

    def transaction_id
      response.xpath("//TransactionId").text
    end
  end
end
