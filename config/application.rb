require_relative "boot"

require "rails/all"
require "rack/cors"  # 追加: rack-cors を読み込みます

Bundler.require(*Rails.groups)

module Expert
  class Application < Rails::Application
    config.load_defaults 7.2
    
    # APIモードの設定
    config.api_only = true

    # CORS 設定を非常に緩くする
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'  # すべてのオリジンを許可
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: false
      end
    end
  end
end
