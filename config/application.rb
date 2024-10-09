require_relative "boot"
require "rails"
require "rack/cors"

# 必要なモジュールのみを読み込み
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie" if defined?(Sprockets)

Bundler.require(*Rails.groups)

module Expert
  class Application < Rails::Application
    config.load_defaults 7.2

    # APIモードの設定
    config.api_only = true

    # CORS設定
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: false
      end
    end

    # ActiveRecordを無効化
    config.generators do |g|
      g.orm :skip
    end
  end
end
