module Netaxept
  class AuthenticationException < Exception; end
  class BBSException < Exception; end
  class MerchantTranslationException < Exception; end
  class UniqueTransactionIdException < Exception; end
  class GenericException < Exception; end
  class ValidationException < Exception; end
  class SecurityException < Exception; end
  class QueryException < Exception; end
end
