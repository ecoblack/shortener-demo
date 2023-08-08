module Services
  module Shortener
    class Create
      BASE_URL = "http://localhost:3000/"

      attr_reader :url, :user_id

      def initialize(url, user_id)
        @url = url
        @user_id = user_id
      end

      def call
        code = generate_unique_code
        pp 'were here'
        pp "#{url}, #{code}, #{user_id}"
        ShortUrl.create(original_url: url, code: code, user_id: user_id)
        "#{BASE_URL}#{code}"
      end

      private

      def generate_unique_code
        @url.hash.abs.to_s(36)[0..5]
      end
    end
  end
end
