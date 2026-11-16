# Mage AI on Railway

This repo is the source of the **Mage AI** template on Railway. It deploys [Mage AI](https://github.com/mage-ai/mage-ai) **0.9.80**, the open-source data pipeline tool (an Airflow alternative), from the official image `mageai/mageai:0.9.80`, pinned by digest in the [`Dockerfile`](Dockerfile).

## What the template deploys

| Service | Source | Data |
|---|---|---|
| **Mage AI** | this repo (`Dockerfile` + `railway-start.sh`) | volume at `/home/src`: the project (`/home/src/default_repo`) and block output and logs (`/home/src/mage_data`) |
| **Postgres** | Railway's PostgreSQL | Mage's metadata: users, pipeline runs, schedules, triggers |

- The web UI is served on the Railway domain on port `6789`. Railway's health check uses `/api/status`.
- Login is required. The owner account is created on the first boot with the email you enter, the username `admin` and a generated password. The start script refuses to run if the password is empty or `admin` (Mage's own fallback).
- Python packages listed in `/home/src/default_repo/requirements.txt` are installed at each start by the image's own `run_app.sh`.

## Variables

| Variable | Default | Notes |
|---|---|---|
| `DEFAULT_OWNER_EMAIL` | *(you enter it)* | Email of the owner account; you log in with it |
| `DEFAULT_OWNER_PASSWORD` | generated secret | Owner password. Read it in the service's Variables tab. Change it in Mage after the first login; changing the variable later doesn't change an existing user |
| `DEFAULT_OWNER_USERNAME` | `admin` | Username of the owner account |
| `JWT_SECRET` | generated secret | Signs login sessions (Mage's built-in default is a public string) |
| `JWT_DOWNLOAD_SECRET` | generated secret | Signs file-download links |
| `MAGE_DATABASE_CONNECTION_URL` | `${{Postgres.DATABASE_URL}}` | Metadata database |
| `MAGE_PUBLIC_HOST` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL, used in API trigger examples |
| `PORT` | `6789` | Port Mage listens on, which the health check uses |

Optional settings you can add yourself: `REQUIRE_USER_AUTHENTICATION=0` turns login off (not recommended on a public domain), `USER_CODE_PATH` and `MAGE_DATA_DIR` move the project and data directories (keep them under `/home/src`), and SMTP, OAuth or LDAP login are described in the [Mage docs](https://docs.mage.ai/production/authentication/overview).

## Updates

Railway tells everyone who deployed this template when a change is merged to `main`. They choose when to apply it. Each update bumps the pinned image in the `Dockerfile` and is described in [`CHANGELOG.md`](CHANGELOG.md), with breaking changes listed first. Back up the volume and the Postgres database before applying a Mage version update: Mage runs its database migrations on start.

## Run it locally

```sh
docker build -t mage-railway .
docker run --rm -p 6789:6789 -e DEFAULT_OWNER_EMAIL=you@example.com -e DEFAULT_OWNER_PASSWORD=change-me-please -v mage-src:/home/src mage-railway
```

Without `MAGE_DATABASE_CONNECTION_URL`, Mage uses SQLite on the volume.
