class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      Rails.logger.info("User id: #{session[:user_id]}")

      access_token = generate_access_token(session[:user_id])
      pp access_token
      render json: { status: 'success', user_id: @user.id, user_email: @user.email, token: access_token }, status: 200
    else
      render json: { error: 'Signup failed', messages: @user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def generate_access_token(user_id)
    payload = { user_id: user_id.to_s, exp: 24.hours.from_now.to_i }
    res = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
    res
  end
end
