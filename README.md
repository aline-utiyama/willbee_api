# README: How to Run the Rails API with PostgreSQL

## Prerequisites

Before running the Rails API, ensure that the following software is installed:

1. **Ruby 3.2.2**

   - Use a version manager like [rbenv](https://github.com/rbenv/rbenv) or [RVM](https://rvm.io/) to install Ruby 3.2.2.
     ```bash
     rbenv install 3.2.2
     rbenv global 3.2.2
     ```

2. **Rails 8.0.1**

   - Rails is included in the Gemfile. Bundler will install it.

3. **PostgreSQL**

   - Install PostgreSQL:

     ```bash
     # For Linux (Debian/Ubuntu):
     sudo apt install postgresql postgresql-contrib

     # For macOS:
     brew install postgresql
     ```

   - Ensure PostgreSQL is running:
     ```bash
     sudo service postgresql start  # Linux
     brew services start postgresql  # macOS
     ```

4. **Bundler**
   - Bundler manages Ruby gems:
     ```bash
     gem install bundler
     ```

---

## Step-by-Step Instructions

### 1. Clone the Repository

Clone the Rails API repository to your local machine:

```bash
git clone <repository-url>
cd <repository-folder>
```

### 2. Install Dependencies

Install the required Ruby gems using Bundler:

```bash
bundle install
```

### 3. Configure the Database (Optional)

1. Open the `config/database.yml` file and ensure it is configured for PostgreSQL:

   ```yaml
   default: &default
     adapter: postgresql
     encoding: unicode
     pool: 5
     username: <your_postgresql_username>
     password: <your_postgresql_password>
     host: localhost

   development:
     <<: *default
     database: <your_database_name>_development

   test:
     <<: *default
     database: <your_database_name>_test

   production:
     <<: *default
     database: <your_database_name>_production
     username: <your_production_username>
     password: <your_production_password>
   ```

2. Replace `<your_postgresql_username>` and `<your_postgresql_password>` with your PostgreSQL credentials.
3. Replace `<your_database_name>` with the desired database name for your environment.

### 4. Set Up the Database

Run the following commands to create and set up the database:

```bash
bin/rails db:create db:migrate
```

### 5. Start the Rails Server

Start the Rails API server:

```bash
bin/rails server
```

By default, the server will be available at `http://localhost:4000`.

---

## Running Redis and Sidekiq

To ensure background jobs are processed correctly, make sure you have Redis installed and running before starting Sidekiq.

### 1. Start Redis Server

If Redis is not installed, install it using:

```bash
# macOS (using Homebrew)
brew install redis

# Ubuntu/Debian
sudo apt update && sudo apt install redis-server

# Windows (via WSL recommended)
sudo apt install redis-server
```

Once installed, start Redis with:

```bash
redis-server
```

You can check if Redis is running with:

```bash
redis-cli ping
```

If it responds with `PONG`, Redis is running successfully.

### 2. Start Sidekiq

Ensure you have Sidekiq installed in your Rails project. If not, add it to your Gemfile:

```ruby
gem 'sidekiq'
```

Then install the gem:

```bash
bundle install
```

Run Sidekiq with:

```bash
bundle exec sidekiq
```

Sidekiq should now be processing jobs. Check the logs for any errors.

---

## Additional Commands

### Running the Rails Console

To interact with the Rails application in the console:

```bash
bin/rails console
```

### Running Tests

If the application includes tests, you can run them using:

```bash
bin/rspec            # For RSpec
```

### Precompile Assets (Optional)

If you need to precompile assets for production:

```bash
bin/rails assets:precompile
```

---

## Troubleshooting

1. **Database Connection Errors**:

   - Ensure PostgreSQL is running.
   - Verify the credentials in `config/database.yml`.
   - Check that the database exists:
     ```bash
     psql -U <username> -d postgres
     \l  # List all databases
     ```

2. **Missing Gems**:

   - Run `bundle install` again.

3. **Port Already in Use**:
   - If port `3000` is occupied, specify a different port when starting the server:
     ```bash
     bin/rails server -p 3001
     ```

---

## Quick Setup Commands

```bash
# Clone the repo
git clone <repository-url>
cd <repository-folder>

# If repo is already cloned, update the repo with the most recent version
git pull origin main

# Install Ruby gems
bundle install

# Configure the database and run migrations
bin/rails db:create db:migrate db:seed

# Start Redis server
redis-server

# Start Sidekiq
bundle exec sidekiq

# Start the Rails server
bin/rails server
```

---

## Notes

- Ensure you are running the correct versions of Ruby and Rails as specified.
- If using Docker, refer to the project's Docker setup instructions (if available).
- Contact the project maintainer for any additional configuration requirements.
