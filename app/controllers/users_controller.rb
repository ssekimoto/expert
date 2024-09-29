class UsersController < ApplicationController
    # ユーザー一覧を取得
    def index
      @users = User.all
      render json: @users
    end
  
    # 特定のユーザーを取得
    def show
      @user = User.find(params[:id])
      render json: @user
    end
  
    # ユーザーを追加
    def create
      @user = User.new(user_params)
  
      if @user.save
        render json: @user, status: :created
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # ユーザーを更新
    def update
      @user = User.find(params[:id])
  
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # ユーザーを削除
    def destroy
      @user = User.find(params[:id])
  
      if @user.destroy
        render json: { message: "User deleted successfully." }, status: :ok
      else
        render json: { error: "Failed to delete user." }, status: :unprocessable_entity
      end
    end
  
    private
  
    # ストロングパラメータ
    def user_params
      params.require(:user).permit(:name, :email, :active)
    end
end
  