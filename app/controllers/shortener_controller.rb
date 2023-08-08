require_relative '../services/shortener/create.rb'

class ShortenerController < ApplicationController
  before_action :set_user_from_token, only: [:index, :create]


  def index
    access_token = request.headers['Authorization']

    pp 'access_token:'
    pp access_token
    pp 'decoded access_token'
    decoded_token = decode_access_token(access_token)
    pp decoded_token

    pp "session user_id #{session[:user_id]}"
    session[:user_id] = decoded_token[:user_id]

    @short_urls = ShortUrl.where(user_id: session[:user_id])
    pp @short_urls
    render json: @short_urls
  end

  def create
    pp session[:user_id]
    user = decode_access_token(request.headers['Authorization'])

    user = User.find(user['user_id'])

    begin
      shortened_url = ::Services::Shortener::Create.new(params[:url], user.id).call
      render json: { shortened_url: shortened_url }
    rescue StandardError => e
      Rails.logger.error("ShortenerService error: #{e.message}")

      render json: { error: "Failed to shorten the URL." }, status: 500
    end
  end

  def show
    shortened_url = ShortUrl.find_by(code: params[:shortcode])

    if shortened_url
      pp shortened_url
      pp "Redireting to #{shortened_url.original_url}"
      if redirect_to shortened_url.original_url.start_with?("http://", "https://") ? params[:url] : "http://#{shortened_url.original_url}", allow_other_host: true
      else
        render plain: 'URL not found', status: :not_found
      end
    end
  end

  private

  def decode_access_token(auth_header)
    token = auth_header.split(' ')[1]  # token value
    decoded_token = JWT.decode(
      token,
      Rails.application.secrets.secret_key_base,
      true,
      { algorithm: 'HS256' })
    decoded_token.first
  rescue JWT::DecodeError => e
    Rails.logger.error("JWT Decode Error: #{e.message}")
    nil
  end

  def set_user_from_token
    return if request.headers['Authorization'] == nil

    @user_id = decode_access_token(request.headers['Authorization'])
  end
end
