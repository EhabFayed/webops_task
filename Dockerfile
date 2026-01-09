# Use Ruby base image
FROM ruby:3.2

# Install dependencies (including libvips for ruby-vips)
RUN apt-get update -qq && \
    apt-get install -y nodejs npm postgresql-client libvips-dev curl

# Set working directory
WORKDIR /app

# Copy only Gemfile first (to optimize caching)
COPY Gemfile ./

# Ensure the platform is added inside Docker
RUN gem install bundler && \
    bundle lock --add-platform x86_64-linux

# Copy Gemfile.lock (after ensuring it exists)
COPY Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application source code
COPY . .

# Copy docker-entrypoint script
COPY bin/docker-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint

# Expose Rails port
EXPOSE 9001

# Use docker-entrypoint as entrypoint
ENTRYPOINT ["docker-entrypoint"]

# Start Rails server
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0"]