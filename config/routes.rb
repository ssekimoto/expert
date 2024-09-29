Rails.application.routes.draw do
  resources :rotations, only: [:index, :show] do
    post :rotate, on: :member # 自動ローテーション用
    post :manual_rotate, on: :member # 手動ローテーション用
    get :monthly_list, on: :member # 今月のリスト
  end

  # ユーザー管理用のルーティング
  resources :users, only: [:index, :show, :create, :update, :destroy]
end

