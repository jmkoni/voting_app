# Voting App

Deployed on Heroku at [https://voting-app-jmk-b6d06fa85d4c.herokuapp.com/](https://voting-app-jmk-b6d06fa85d4c.herokuapp.com/)

## Overview
This app allows users to vote in a simple "election". All votes come in the form of write-ins. There can be no more than 10 candidates. Everyone is given 5 minutes to vote prior to being logged out. You can only vote once. 

## Ruby Version
3.2.2

## Set up
If you have the current ruby version installed (if not, please try RVM or rbenv and install 3.2.2), the following steps will set up this application:

``` shell
brew bundle
bundle install
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails s
```

## Tests
Run the tests with `bundle exec rspec`.
