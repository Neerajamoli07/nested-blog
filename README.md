# Real-Time Blog App — Rails 8

A full-featured real-time blog built on **Rails 8.1** with authentication, nested comments, live updates, notifications, image uploads, search, likes, and an admin dashboard.

## Features

| Feature | Implementation |
|---------|----------------|
| **Authentication** | `has_secure_password`, session-based login/signup |
| **Posts** | CRUD, draft/publish, cover images (Active Storage) |
| **Nested comments** | Self-referential `parent_id`, up to 4 levels deep |
| **Live comments** | Turbo Streams + Action Cable (`turbo_stream_from @post`) |
| **Notifications** | DB records + real-time badge/list updates per user |
| **Image upload** | Post cover images + user avatars (Active Storage) |
| **Search** | PostgreSQL full-text via `pg_search` |
| **Likes** | Polymorphic likes on posts and comments |
| **Admin dashboard** | `/admin` — stats, user roles, post moderation |

## Demo accounts

After `bin/rails db:seed`:

| Email | Password | Role |
|-------|----------|------|
| `admin@example.com` | `password123` | Admin |
| `member@example.com` | `password123` | Member |

## Setup

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000).

### Background jobs

Comment and like notifications run via **Solid Queue**:

```bash
bin/jobs
```

### Live comments demo

1. Sign in as two different users in two browsers (or normal + incognito).
2. Open the same published post.
3. Post a comment in one window — it appears instantly in the other.

## Routes overview

| Path | Description |
|------|-------------|
| `/` | Published posts (+ search via `?q=`) |
| `/login`, `/signup` | Authentication |
| `/posts/:id` | Post detail with live comments |
| `/search?q=` | Full-text search |
| `/notifications` | Notification inbox |
| `/admin` | Admin dashboard (admin only) |

## Tech stack

- Rails 8.1, PostgreSQL, Hotwire (Turbo + Stimulus)
- Action Cable (async dev / Solid Cable production)
- Solid Queue, Solid Cache
- Active Storage, Propshaft, importmap
- pg_search, bcrypt, image_processing

## Testing

```bash
bin/rails test
bin/ci
```

## CI

GitHub Actions runs Brakeman, bundler-audit, importmap audit, RuboCop, and tests on PostgreSQL. See `.github/workflows/ci.yml`.
