# Define Ruby version at the very top
ARG RUBY_VERSION=3.3.5

# Base image with Ruby
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

# Rails app lives here
WORKDIR /jemref

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    libjemalloc2 \
    libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle"
RUN if [ "$RAILS_ENV" = "production" ]; then \
    bundle exec bootsnap precompile app/ lib/; \
fi || true

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile
    
# Copy application code
COPY . .

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN if [ "$RAILS_ENV" = "production" ]; then \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile; \
fi || true

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /jemref /jemref
RUN chmod +x /jemref/bin/docker-entrypoint

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/jemref/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
