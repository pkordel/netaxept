module Netaxept
  class BaseResponse
    attr_reader :response

    def initialize(response)
      @response = Nokogiri::XML response
    end

    def error
      if err_node = response.xpath("//Error").first
        err_class   = err_node.attr("xsi:type")
        err_message = err_node.xpath("//Message").text
        path = "#{Netaxept}::#{err_class}"
        if RUBY_VERSION > '1.9'
          Object.const_get(path).new(err_message)
        else
          constantize(path).new(err_message)
        end
      end
    end

    # TODO: determine whether we should support less than 2.0.0
    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')

      # Trigger a builtin NameError exception including the ill-formed constant in the message.
      Object.const_get(camel_cased_word) if names.empty?

      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check it it's owned
          # directly before we reach Object or the end of ancestors.
          constant = constant.ancestors.inject do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end

  end
end
