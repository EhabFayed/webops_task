class AuthenticationController < ApplicationController
  # Sign up a new user and issue a JWT token
  def signup
    user = User.new(user_params)
    if user.save
      # If successful, issue a token and return it
      token = encode_token(user.id)
      render json: { user: user, token: token }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Login existing user and issue a JWT token
  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      # If credentials are correct, issue a token
      token = encode_token(user.id)
      render json: { user: user, token: token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :image) # Permit all required fields
  end

  # Encode the user's ID into a JWT token
  def encode_token(user_id)
    JWT.encode({ user_id: user_id }, Rails.application.secret_key_base, 'HS256')
  end
end
