# ベースイメージ
FROM ruby:3.2.2

# 作業ディレクトリを作成
WORKDIR /app

# Node.js と Yarn をインストール
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# GemfileとGemfile.lockをコピーしてbundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリケーションのファイルをすべてコピー
COPY . .

# Remove a potentially pre-existing server.pid for Rails.
RUN rm -f /app/tmp/pids/server.pid

# ポートを指定
EXPOSE 3000

# デフォルトのエントリポイントを設定
ENTRYPOINT ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails db:migrate && bundle exec rails server -b 0.0.0.0 -p 3000"]
