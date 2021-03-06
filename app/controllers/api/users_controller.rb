class Api::UsersController < ApplicationController
#   skips authorization before user signs up
    skip_before_action :authorize, only:[:create, :index]
    def show
        @user = User.find(params[:id])
        render json: @user, include:[:candidate_users]
    end
    def index 
        users = User.all
        render json: users, include: [:candidate_users]
       
    end

   
  
    def create
        @user = User.create(user_params)
        if @user.valid?
            @token = encode_token(user_id: @user.id)
            render json: { user: @user, jwt:@token }, status: :created
        else
            render json: {error: "failed to create user"}, status: :not_acceptable
        end 
    end

   

    private
    def user_params
      params.require(:user).permit(:username, :password, :id)
    end
    def encode_token(payload)
        JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
      end
end
