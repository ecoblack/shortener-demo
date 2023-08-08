class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:loginEmail])
    if user && user.authenticate(params[:loginPassword])

      session[:user_id] = user.id
      Rails.logger.info("User id: #{session[:user_id]}")

      access_token = generate_access_token(session[:user_id])
      pp access_token
      render json: { status: 'success', user_id: user.id, user_email: user.email, token: access_token }, status: 200
    else
      render json: { status: 'error', message: 'Invalid email or password' }, status: 401
    end
  end

  private

  def generate_access_token(user_id)
    payload = { user_id: user_id.to_s, exp: 24.hours.from_now.to_i }
    res = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
    res
  end
end
