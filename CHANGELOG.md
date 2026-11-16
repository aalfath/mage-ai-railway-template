# Changelog

Each entry is one version of this Railway template. Breaking changes are listed first.

## 0.9.80 (2026-11-16)

- First release: Mage AI 0.9.80 (`mageai/mageai:0.9.80@sha256:73c8e808070ef55ffe263544809197820f38ca621349b5a8ed7d6366cb861cc8`).
- Railway Postgres stores Mage's metadata (users, pipeline runs, schedules, triggers).
- The project files and block output stay on a volume mounted at `/home/src`.
- Login is required. The owner account gets a generated password, and the container refuses to start without one.
