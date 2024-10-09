class RotationsController < ApplicationController
  before_action :set_rotation, only: [:show, :rotate, :manual_rotate, :monthly_list]

  # ローテーションの一覧を取得
  def index
    rotations = FirestoreService.col("rotations").get.map do |doc|
      data = doc.data
      {
        id: doc.document_id,
        current_user_id: data[:current_user_id],
        created_at: data[:created_at],
        updated_at: data[:updated_at],
        current_user: fetch_user(data[:current_user_id])
      }
    end
    render json: rotations
  end

  # 特定のローテーションを表示
  def show
    rotation = {
      id: @rotation.document_id,
      current_user_id: @rotation[:current_user_id],
      created_at: @rotation[:created_at],
      updated_at: @rotation[:updated_at],
      current_user: fetch_user(@rotation[:current_user_id])
    }
    render json: rotation
  end

  # 担当者を自動で次にローテーションする
  def rotate
    next_user_id = find_next_user_id
    update_rotation(next_user_id)

    # 担当者の変更通知
    begin
      NotificationService.notify_rotation_change(fetch_user(next_user_id))
    rescue => e
      Rails.logger.warn("Notification failed: #{e.message}")
    end

    render json: { message: "次の担当者は #{fetch_user(next_user_id)[:name]} です。" }, status: :ok
  end

  # 手動で次の担当者に回す
  def manual_rotate
    next_user_id = find_next_user_id
    update_rotation(next_user_id)

    # 担当者の変更通知
    begin
      NotificationService.notify_rotation_change(fetch_user(next_user_id))
    rescue => e
      Rails.logger.warn("Notification failed: #{e.message}")
    end

    render json: { message: "次の担当者は #{fetch_user(next_user_id)[:name]} です。" }, status: :ok
  end

  # 今月のローテーションリストを取得
  def monthly_list
    active_users = fetch_active_users

    if active_users.empty?
      return render json: { error: 'No active users available for rotation' }, status: :unprocessable_entity
    end

    current_user = fetch_user(@rotation[:current_user_id]) || active_users.first
    current_index = active_users.index { |user| user[:id] == current_user[:id] }
    monthly_rotation = []

    (0..3).each do |week|
      next_user = active_users[(current_index + week) % active_users.size]
      monthly_rotation << { week: week + 1, user: next_user[:name] }
    end

    render json: { monthly_rotation: monthly_rotation }, status: :ok
  end

  private

  def set_rotation
    @rotation = FirestoreService.col("rotations").doc(params[:id]).get
  end

  def fetch_user(user_id)
    user_doc = FirestoreService.col("users").doc(user_id).get
    user_doc.exists? ? user_doc.data.merge(id: user_doc.document_id) : nil
  end

  def fetch_active_users
    FirestoreService.col("users").where("active", "==", true).get.map do |doc|
      doc.data.merge(id: doc.document_id)
    end
  end

  def find_next_user_id
    active_users = fetch_active_users
    current_user = fetch_user(@rotation[:current_user_id]) || active_users.first
    current_index = active_users.index { |user| user[:id] == current_user[:id] }
    next_user = active_users[(current_index + 1) % active_users.size]
    next_user[:id]
  end

  def update_rotation(user_id)
    FirestoreService.col("rotations").doc(params[:id]).set({ current_user_id: user_id }, merge: true)
  end
end
