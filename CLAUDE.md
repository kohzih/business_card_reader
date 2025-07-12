# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 8.0.2 application named `BusinessCardReader` designed for business card reading functionality. The application uses modern Rails features including Hotwire (Turbo + Stimulus), SQLite databases, and Docker deployment via Kamal.

## Development Commands

### Server and Development
- `bin/rails server` or `bin/rails s` - Start development server (default port 3000)
- `bin/rails console` or `bin/rails c` - Start Rails console
- `bin/rails dbconsole` or `bin/rails dbc` - Start database console

### Database Operations
- `bin/rails db:create` - Create databases
- `bin/rails db:migrate` - Run migrations
- `bin/rails db:seed` - Load seed data
- `bin/rails db:setup` - Create, migrate, and seed in one command
- `bin/rails db:reset` - Drop, create, migrate, and seed
- `bin/rails db:rollback STEP=n` - Rollback n migrations

### Code Quality and Testing
- `bundle exec rubocop` - Run RuboCop linter (uses rails-omakase configuration)
- `bundle exec brakeman` - Run security analysis
- System tests are disabled (config.generators.system_tests = nil)

### Asset Management
- `bin/rails assets:precompile` - Compile assets for production
- `bin/rails assets:clean` - Remove old compiled assets

### Background Jobs
- `bin/rails solid_queue:start` - Start Solid Queue supervisor for background jobs
- Jobs run inside Puma process in development (SOLID_QUEUE_IN_PUMA=true)

### Deployment
- `bin/kamal deploy` - Deploy application using Kamal
- `bin/kamal console` - Access Rails console on deployed app
- `bin/kamal shell` - Access shell on deployed app
- `bin/kamal logs` - View application logs

## Architecture and Configuration

### Database Setup
- **Development**: SQLite3 at `storage/development.sqlite3`
- **Test**: SQLite3 at `storage/test.sqlite3`
- **Production**: Multi-database setup with separate databases for:
  - Primary: `storage/production.sqlite3`
  - Cache: `storage/production_cache.sqlite3`
  - Queue: `storage/production_queue.sqlite3`
  - Cable: `storage/production_cable.sqlite3`

### Modern Rails Stack
- **Frontend**: Hotwire (Turbo + Stimulus) with ImportMap for JavaScript
- **Background Jobs**: Solid Queue (database-backed)
- **Caching**: Solid Cache (database-backed)
- **WebSockets**: Solid Cable for Action Cable
- **Assets**: Propshaft asset pipeline

### Code Standards
- RuboCop configuration inherits from `rubocop-rails-omakase`
- Autoloads `lib/` directory (excluding `assets` and `tasks`)
- Modern browser requirement enforced in ApplicationController

### Deployment Configuration
- **Container**: Docker-based deployment via Kamal
- **SSL**: Auto-certification via Let's Encrypt
- **Storage**: Persistent volume at `/rails/storage` for SQLite files and Active Storage
- **Registry**: Configured for Docker Hub (customizable)

### Key Application Settings
- Module name: `BusinessCardReader`
- Rails 8.0 defaults loaded
- System tests disabled
- Test framework not included (rails/test_unit/railtie commented out)

## Development Notes

- The application currently has minimal functionality - it's a fresh Rails application ready for business card reading features
- No specific business card processing logic has been implemented yet
- Routes file only contains health check endpoint - root route needs to be defined
- Uses memory store for caching in development
- Active Storage configured for local file storage in development