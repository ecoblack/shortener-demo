# frozen_string_literal: true

module Services
  module Jwt
    class Decode
      attr_reader :token, :error_messages

      def initialize(token, secret)
        @token = token
        @secret = secret
        @error_messages = []
      end

      def call
        return nil unless decode && parse_payload

        {
          exp_time: @exp_time,
          user: @user
        }
      end

      private

      def decode
        begin
          @decoded = JWT.decode(@token, @secret, false)[0]
          HashWithIndifferentAccess.new @decoded
        rescue JWT::ExpiredSignature, JWT::VerificationError => e
          @error_messages << e.message
          return false
        rescue JWT::DecodeError, JWT::VerificationError => e
          @error_messages << e.message
          return false
        end
        true
      end

      def parse_payload
        @exp_time = Time.at(@decoded['exp'])
        @user = User.find_by(uid: @decoded['uid'])
        @user.present?
      end
    end
  end
end
