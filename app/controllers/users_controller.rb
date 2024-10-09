class UsersController < ApplicationController
  # ユーザー一覧を取得
  def index
    users = FirestoreService.col("users").get.map do |doc|
      doc.data.merge(id: doc.document_id)
    end
    render json: users
  end

  # 特定のユーザーを取得
  def show
    user_doc = FirestoreService.col("users").doc(params[:id]).get
    if user_doc.exists?
      render json: user_doc.data.merge(id: user_doc.document_id)
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  # ユーザーを追加
  def create
    new_user_id = SecureRandom.uuid
    FirestoreService.col("users").doc(new_user_id).set(user_params)
    render json: { id: new_user_id, **user_params }, status: :created
  end

  # ユーザーを更新
  def update
    user_doc = FirestoreService.col("users").doc(params[:id])
    if user_doc.get.exists?
      user_doc.set(user_params, merge: true)
      render json: { id: params[:id], **user_params }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  # ユーザーを削除
  def destroy
    user_doc = FirestoreService.col("users").doc(params[:id])
    if user_doc.get.exists?
      user_doc.delete
      render json: { message: "User deleted successfully." }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :active).to_h.symbolize_keys
  end
end