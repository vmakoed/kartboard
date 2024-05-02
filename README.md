# README

## Local development

1. Install and switch to the ruby version specified in `.ruby-version`
2. Run `bundle install` to install dependencies
3. Run `rails db:setup` to create the database
4. Start the server by running  `bin/dev`

## Environment variables

Loaded from `.env` file at the root of the project: 
https://github.com/bkeepers/dotenv.

## Authentication

1. Get Client ID and Client Secret from Google at 
https://console.cloud.google.com/apis/credentials
2. Add `http://<host>/auth/google_oauth2/callback` to Authorised redirect URIs
where `host` is the domain of the application (e.g. `localhost:3000` for local 
development)
3. Set the environment variables `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`

Optional: restrict the list of allowed emails 
* Set a comma-separated list with emails to `ALLOWED_EMAILS` environment 
variable
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

## BambooHR integration

If your organization is using BambooHR and [directory API](
<https://documentation.bamboohr.com/reference/get-employees-directory-1>
) is enabled, you can create or update user accounts by calling `Users::Sync`
service. Specify the following environment variables:
* `BAMBOOHR_API_KEY`
* `BAMBOOHR_SUBDOMAIN`

Check out [BambooHR API documentation](
<https://documentation.bamboohr.com/docs/getting-started#section-authentication>
) 
for more information.

The integration syncs user pictures as well. ActiveStorage will try to purge old
profile pictures after attaching new one. This is done asynchronously.
Because of SQLite limitations, this might fail with a `SQLITE_BUSY` when
processing several users at once.

Because of that, in order to purge old pictures, you need to run the following
after the sync:
```ruby
ActiveStorage::Blob.unattached.each(&:purge)
```

This is a temporary workaround that will not be necessary after a migration to a 
more performant database like PostgreSQL.
