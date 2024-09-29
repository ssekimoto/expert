class RotationsController < ApplicationController
    before_action :set_rotation, only: [:show, :rotate, :manual_rotate, :monthly_list]
  
    # ローテーションの一覧を取得
    def index
      @rotations = Rotation.all
      render json: @rotations, include: :current_user
    end
  
    # 特定のローテーションを表示
    def show
      render json: @rotation, include: :current_user
    end
  
    # 担当者を自動で次にローテーションする
    def rotate
      @rotation.rotate!
      
      # 担当者の変更通知
      begin
        NotificationService.notify_rotation_change(@rotation.current_user)
      rescue => e
        Rails.logger.warn("Notification failed: #{e.message}")
      end
  
      render json: { message: "次の担当者は #{@rotation.current_user.name} です。" }, status: :ok
    end
  
    # 手動で次の担当者に回す
    def manual_rotate
      next_user = @rotation.next_user
      @rotation.update(current_user: next_user)
  
      # 担当者の変更通知
      begin
        NotificationService.notify_rotation_change(next_user)
      rescue => e
        Rails.logger.warn("Notification failed: #{e.message}")
      end
  
      render json: { message: "次の担当者は #{next_user.name} です。" }, status: :ok
    end
  
    # 今月のローテーションリストを取得
    def monthly_list
      users = User.active.to_a
  
      # アクティブユーザーがいない場合、エラーメッセージを返す
      if users.empty?
        return render json: { error: 'No active users available for rotation' }, status: :unprocessable_entity
      end
  
      # current_user が存在しない場合は最初のアクティブユーザーを割り当て
      current_user = @rotation.current_user || users.first
  
      # 現在の担当者が存在しない場合のエラーハンドリング
      unless current_user
        return render json: { error: 'No current user found for rotation' }, status: :unprocessable_entity
      end
  
      # 現在の担当者から1ヶ月分のリストを作成
      current_index = users.index(current_user)
      monthly_rotation = []
  
      (0..3).each do |week|
        next_user = users[(current_index + week) % users.size]
        monthly_rotation << { week: week + 1, user: next_user.name }
      end
  
      render json: { monthly_rotation: monthly_rotation }, status: :ok
    end
  
    private
  
    def set_rotation
      @rotation = Rotation.find(params[:id])
    end
end
  