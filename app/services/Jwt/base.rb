module Services
  module Jwt
    class Base

      def initialize(access_token)
        @secret = Rails.application.credentials[:secret_key_base].to_s
        @algorithm = 'HS256'
      end

    end
  end
end
