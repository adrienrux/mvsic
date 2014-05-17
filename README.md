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

In terminal, open up psql: `psql` then run `create role mvsic with createdb login password 'password'

5) Create & migrate databases

`bundle exec rake db:create`

`bundle exec rake db:migrate`

5) Start server

`rails s`
