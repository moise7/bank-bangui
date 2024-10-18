# # FROM ruby:3.2.0

# # # Install necessary system dependencies
# # RUN apt-get update -qq && apt-get install -y \
# #     build-essential \
# #     libxml2-dev \
# #     libxslt-dev \
# #     nodejs \
# #     yarn \
# #     git \
# #     tzdata \
# #     postgresql-client

# # # Ensure the correct bundler version is installed
# # RUN gem install bundler -v '2.5.17'

# # # Create and set the working directory
# # WORKDIR /app

# # # Copy Gemfile and Gemfile.lock first to leverage Docker cache
# # COPY Gemfile Gemfile.lock ./

# # # Set up bundler path and install dependencies
# # ENV BUNDLE_PATH=/gems
# # RUN bundle install --retry=3

# # # Copy the rest of the application code into the image
# # COPY . .

# # # Make sure the bin directory is executable
# # RUN chmod +x bin/*

# # # Command to run the Rails app with `bundle exec`
# # CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# # # Expose the port for the Rails server
# # EXPOSE 3000


# FROM ruby:3.2.0

# # Install necessary system dependencies
# RUN apt-get update -qq && apt-get install -y \
#     build-essential \
#     libxml2-dev \
#     libxslt-dev \
#     nodejs \
#     yarn \
#     git \
#     tzdata \
#     postgresql-client \
#     libpq-dev \
#     pkg-config

# # Ensure the correct bundler version is installed
# RUN gem install bundler -v '2.5.17'

# # Create and set the working directory
# WORKDIR /app

# # Copy Gemfile and Gemfile.lock first to leverage Docker cache
# COPY Gemfile Gemfile.lock ./

# # Set up bundler path and install dependencies
# ENV BUNDLE_PATH=/gems
# RUN bundle install --retry=3

# # Copy the rest of the application code into the image
# COPY . .

# # Ensure the bin directory is executable
# RUN chmod +x bin/*

# # Ensure that Docker uses the correct Ruby version
# ARG RUBY_VERSION=3.2.0

# # Command to run the Rails app with `bundle exec`
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# # Expose the port for the Rails server
# EXPOSE 3000


# Use the official Ruby image
FROM ruby:3.2.0

# Install necessary system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    yarn \
    git \
    tzdata \
    postgresql-client \
    libpq-dev \
    pkg-config

# Ensure the correct bundler version is installed
RUN gem install bundler -v '2.5.17'

# Create and set the working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock first to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Set up bundler path and install dependencies
ENV BUNDLE_PATH=/gems
RUN bundle install --retry=3

# Copy the rest of the application code into the image
COPY . .

# Ensure the bin directory is executable
RUN chmod +x bin/*

# Command to run the Rails app with `bundle exec`
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# Expose the port for the Rails server
EXPOSE 3000

