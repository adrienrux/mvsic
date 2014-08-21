mvsic
=====

### Initial setup

1) Clone the repository:

```
git clone https://github.com/jamesfzhang/mvsic.git
```

2) Install gems

```
bundle install
```

3) Setup Postgres

Download and install [Postgres.app](http://postgresapp.com/)

Add `export PGHOST=localhost` to `~/.bash_profile` then `source ~/.bash_profile`

4) Setup Postgres role

In terminal, open up psql: `psql` then run `create role mvsic with createdb login password 'password'`

5) Create, migrate, and seed databases

`bundle exec rake db:create`

`bundle exec rake db:migrate`

`bundle exec rake db:seed`

6) Set up `.env` file at root

`touch .env`

Ask James for Mailchimp's API key and add it like so to `.env`:

`MAILCHIMP_API_KEY: '123456'`

7) Start redis

If you don't have redis, install it first via homebrew

`brew install redis`

Once it's installed, start it

`redis-server &`

8) Start server

`bundle exec rails s`

### Use production database dump

Capture database backup

`heroku pgbackups:capture`

Download it

`curl -o latest.dump `heroku pgbackups:url``

Run this and replace 'jameszhang' with your username

`pg_restore --verbose --clean --no-acl --no-owner -h localhost -U jameszhang -d mvsic_development latest.dump`
