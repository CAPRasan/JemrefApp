# Rubyのバージョン指定
ARG RUBY_VERSION=3.3.5

# Rubyベースイメージの作成
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

# ディレクトリの指定
WORKDIR /jemref

# 関連パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    libjemalloc2 \
    libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# development環境をデフォルトに設定
ENV RAILS_ENV=${RAILS_ENV:-development} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle"


# イメージのサイズダウンのためベースイメージを一旦廃棄
FROM base AS build

# gem構築のためのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# gemのインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile
    
# アプリケーションコードのコピー
COPY . .

# アセットのプリコンパイル（本番環境のみ）
RUN if [ "$RAILS_ENV" = "production" ]; then \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile; \
fi || true

# 以下、本番環境用に最適化するための最終ステージ
FROM base

# 起動時間短縮のため、コンパイル済みのアセットをベースイメージにコピー
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /jemref /jemref
RUN chmod +x /jemref/bin/docker-entrypoint

# 非ルートユーザーに部分的な実行権限をもたせ、セキュリティを強化
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# データベース準備のためentrypointを実行
ENTRYPOINT ["/jemref/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
