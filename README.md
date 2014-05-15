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

Download install [Postgres.app](http://postgresapp.com/)

Add `export PGHOST=localhost` to `~/.bash_profile` then `source ~/.bash_profile`

4) Create & migrate databases

`bundle exec rake db:create`

`bundle exec rake db:migrate`

5) Start server

`rails s`
