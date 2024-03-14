# README

## Environment variables

Loaded from `.env` file at the root of the project: 
https://github.com/bkeepers/dotenv.

## Authentication

* Get Client ID and Client Secret from Google at 
https://console.cloud.google.com/apis/credentials

* Add `http://<host>/auth/google_oauth2/callback` to Authorised redirect URIs

* Set the environment variables `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`

* Optional: use `ALLOWED_EMAILS` to restrict the list of allowed emails (a 
comma-separated list)
  * Use `ALLOWED_DOMAINS` to allow all emails from specific domains
  * If you are running tests, make sure these variables are set to empty values
(use `.env.test.local`)

## Deployment

Install Kamal: https://kamal-deploy.org/docs/installation.

Set the following environment variables:
* `RAILS_MASTER_KEY`: contents of `config/master.key`
* `KAMAL_REGISTRY_PASSWORD`: password for the Docker Hub account

In `config/deploy.yml`, configure the following:
  * `service`: application name
  * `image`: Docker image name
  * `servers/web/hosts`: server IPs
  * `servers/web/hosts/labels/traefik.http.routers.blog.rule`: router 
configuration
    * example: ``Host(`example.com`)``, see 
https://doc.traefik.io/traefik/routing/routers/
  * `registry/username`: Docker Hub username
  * `traefik/options/args/certificatesResolvers.letsencrypt.acme.email`: email 
for Let's Encrypt

Use `kamal setup` to deploy to the servers.
