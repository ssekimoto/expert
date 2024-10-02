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

# スクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# デフォルトのエントリポイントを設定
ENTRYPOINT ["entrypoint.sh"]

# ポートとサーバーの起動
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
