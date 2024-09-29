require 'net/http'
require 'uri'
require 'json'

class NotificationService
  SLACK_WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL'] || 'http://localhost:3001/webhook'

  def self.notify_rotation_change(user)
    message = "新しい監視担当者は #{user.name} です。"
    send_to_webhook(message)
  end

  private

  def self.send_to_webhook(message)
    uri = URI.parse(SLACK_WEBHOOK_URL)
    header = { 'Content-Type': 'application/json' }
    payload = { text: message, username: 'Rotation Notifier', icon_emoji: ':rotating_light:' }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = payload

    response = http.request(request)
    Rails.logger.error "Slack通知に失敗しました: #{response.body}" unless response.is_a?(Net::HTTPSuccess)
  end
end
