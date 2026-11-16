# Changelog

Each entry is one version of this Railway template. Breaking changes are listed first.

## 0.9.80, README button (2026-11-16)

- README: Deploy on Railway button for the published template `mage-ai-1`. No change to the image or the start script.

## 0.9.80 (2026-11-16)

- First release: Mage AI 0.9.80 (`mageai/mageai:0.9.80@sha256:73c8e808070ef55ffe263544809197820f38ca621349b5a8ed7d6366cb861cc8`).
- Railway Postgres stores Mage's metadata (users, pipeline runs, schedules, triggers).
- The project files and block output stay on a volume mounted at `/home/src`.
- The Dockerfile flattens the upstream image into one layer. Without that, numpy 2 files that the upstream image deletes came back on Railway, and Mage crash-looped on start (`All ufuncs must have type numpy.ufunc`).
- Login is required. The owner account gets a generated password, and the container refuses to start without one.
