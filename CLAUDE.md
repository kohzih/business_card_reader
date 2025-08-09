# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 8.0.2 application named `BusinessCardReader` that provides business card image analysis and data extraction using Google Gemini 2.5 Flash API. The application allows users to upload business card images and automatically extracts structured information such as names, companies, contact details, and addresses. It uses modern Rails features including Hotwire (Turbo + Stimulus), SQLite databases, and supports both Docker deployment via Kamal and Render.com deployment.

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
- No test framework is currently configured (test_unit/railtie commented out)
- System tests are disabled (config.generators.system_tests = nil)

### Asset Management
- `bin/rails assets:precompile` - Compile assets for production
- `bin/rails assets:clean` - Remove old compiled assets

### Background Jobs
- `bin/rails solid_queue:start` - Start Solid Queue supervisor for background jobs
- Jobs run inside Puma process in development (SOLID_QUEUE_IN_PUMA=true)

### Deployment

#### Kamal Deployment (Docker)
- `bin/kamal deploy` - Deploy application using Kamal
- `bin/kamal console` - Access Rails console on deployed app
- `bin/kamal shell` - Access shell on deployed app
- `bin/kamal logs` - View application logs

#### Render.com Deployment
- Configuration available in `render.yaml`
- Auto-deploys from main branch
- Uses SQLite with migrations run on startup
- Free tier deployment ready

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
- **Image Processing**: Active Storage with ImageProcessing gem
- **AI Integration**: ruby-gemini gem for Google Gemini API

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
- Google Gemini API key stored in encrypted credentials
- Image uploads restricted to JPEG/PNG formats
- Uses Gemini 2.5 Flash model for business card analysis

## Application Architecture

### Core Components

#### Business Card Model (`app/models/business_card.rb`)
- Has one attached image via Active Storage
- Validates image presence and format (JPEG/PNG only)
- Database fields: `full_name`, `company_name`, `department`, `post`, `telephone_number`, `mail`, `address`, `raw_response`

#### Gemini Service (`app/services/gemini_service.rb`)
- Integrates with Google Gemini 2.5 Flash API via ruby-gemini gem
- Converts uploaded images to base64 for API processing
- Uses structured Japanese prompt for business card data extraction
- Returns parsed JSON data or error information
- Handles API errors and JSON parsing failures

#### Business Cards Controller (`app/controllers/business_cards_controller.rb`)
- RESTful controller with `new`, `create`, and `show` actions
- Handles image upload and processing workflow
- Calls GeminiService for AI analysis
- Updates business card record with extracted data

### Routes Configuration
- Root route points to `business_cards#new`
- RESTful routes for business cards (limited to `new`, `create`, `show`)
- Health check endpoint at `/up`

### Credentials and Security
- Google API key stored in `rails credentials` as `google_api_key`
- CSRF protection enabled
- File upload validation prevents non-image files
- Uses encrypted credentials for sensitive data

## API Integration Details

### Google Gemini Configuration
- Model: `gemini-2.5-flash`
- Requires API key from Google AI Studio (https://aistudio.google.com/)
- Processes images via base64 encoding
- Uses structured JSON response format
- Handles Japanese text extraction with specific field mapping

### Error Handling
- Service returns success/failure status with error messages
- Raw API responses stored in `raw_response` field for debugging
- JSON parsing errors caught and reported
- API connection errors handled gracefully

## Development Notes

- Application is fully functional for business card reading
- Japanese language interface and prompts
- Uses memory store for caching in development
- Active Storage configured for local file storage in development
- No authentication system implemented
- Single-page workflow: upload → process → display results