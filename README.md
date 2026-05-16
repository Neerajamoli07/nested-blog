# Blog App — Rails 8 with Nested Comments

A full-featured blog built on **Rails 8.1** demonstrating modern Rails defaults: Hotwire (Turbo + Stimulus), Propshaft, import maps, PostgreSQL, and the Solid adapters (Cache, Queue, Cable). Posts support draft/published workflow; comments support **nested replies** up to four levels deep with real-time UI updates via Turbo Streams.

![Rails](https://img.shields.io/badge/Rails-8.1-red)
![Ruby](https://img.shields.io/badge/Ruby-3.x-red)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-9.5+-blue)

## Features

### Blog posts
- Create, edit, and delete posts
- **Draft / published** status with `enum` and automatic `published_at` timestamp
- One-click **Publish** action for drafts
- Post list with excerpts, status badges, and comment counts (counter cache)

### Nested comments
- Threaded discussions with **self-referential** `parent_id` on `Comment`
- Up to **4 levels** of nesting (configurable in `CommentsHelper`)
- **Turbo Streams** — add or remove comments without full page reloads
- **Stimulus** controllers for reply toggles, auto-growing textareas, and dismissible flash messages
- **Solid Queue** background job (`CommentNotificationJob`) runs after each new comment

### Rails 8 stack highlights
| Technology | Purpose |
|------------|---------|
| **Hotwire** (Turbo + Stimulus) | SPA-like UX without a heavy JS framework |
| **Propshaft** | Modern asset pipeline |
| **importmap-rails** | ESM JavaScript without Node bundlers |
| **solid_cache** | Database-backed cache (production) |
| **solid_queue** | Database-backed Active Job adapter |
| **solid_cable** | Database-backed Action Cable |
| **Kamal + Docker** | Deployment-ready container setup |
| **allow_browser :modern** | Serves only to modern browsers |
| **stale_when_importmap_changes** | Smart HTTP caching for HTML |

## Requirements

- Ruby 3.2+ (see `.ruby-version`)
- PostgreSQL 9.5+
- Bundler 2.x

## Setup

```bash
# Install gems
bundle install

# Configure database (edit config/database.yml if needed)
# Default development DB: blog_app_development1

# Create and migrate
bin/rails db:create db:migrate

# Seed sample posts and nested comments
bin/rails db:seed

# Start the server
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000).

### Database configuration

Development defaults in `config/database.yml`:

```yaml
database: blog_app_development1
username: dev
password: dev
host: localhost
port: 5432
```

Adjust credentials for your environment.

### Background jobs (Solid Queue)

In development, jobs run via the async adapter. For production-style processing:

```bash
bin/jobs
```

## Usage

1. **Home** — lists all posts (newest first).
2. **New Post** — create a post; choose **Draft** or **Published**.
3. **Post page** — read content, publish drafts, edit/delete, and comment.
4. **Comments** — type a top-level comment and submit.
5. **Reply** — click **Reply** on any comment (up to 4 levels deep).
6. **Delete** — remove a comment and all its nested replies.

## Architecture

### Models

```
Post
├── has_many :comments
├── has_many :root_comments (parent_id IS NULL)
└── enum status: { draft, published }

Comment
├── belongs_to :post (counter_cache: comments_count)
├── belongs_to :parent (optional, class_name: "Comment")
└── has_many :replies (dependent: :destroy)
```

### Routes

```ruby
resources :posts do
  member { patch :publish }
  resources :comments, only: [:create, :destroy]
end
root "posts#index"
```

### Real-time comment flow

1. User submits a comment form (`CommentsController#create`).
2. Controller responds with `create.turbo_stream.erb`.
3. Turbo Stream **appends** the new comment to `#comments` (root) or the parent's `#comment_*_replies` container (nested).
4. Comment count and forms reset via additional stream updates.

### Stimulus controllers

| Controller | Role |
|------------|------|
| `flash` | Auto-dismiss notices after 5 seconds |
| `reply` | Toggle/cancel nested reply forms |
| `autosize` | Grow comment textareas as you type |

## Testing

```bash
bin/rails test
```

Includes model, controller, and integration tests for posts, nested comments, Turbo Stream responses, and background job enqueueing.

## Project structure

```
app/
├── controllers/
│   ├── posts_controller.rb
│   └── comments_controller.rb
├── models/
│   ├── post.rb
│   └── comment.rb
├── views/
│   ├── posts/
│   └── comments/          # partials + turbo_stream templates
├── javascript/controllers/  # Stimulus
└── jobs/
    └── comment_notification_job.rb
db/
├── migrate/
└── seeds.rb
```

## Deployment

This app includes **Kamal** and a **Dockerfile** for container deployment. See `config/deploy.yml` and `.kamal/` for production configuration. Production uses separate PostgreSQL databases for primary, cache, queue, and cable workloads.

```bash
bin/kamal setup   # first-time server setup
bin/kamal deploy  # deploy new version
```

## CI

GitHub Actions workflow in `.github/workflows/ci.yml` runs security scans and tests.

## License

This project is provided as a learning reference. Use and modify freely.
