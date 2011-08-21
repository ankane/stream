# Stream

Fun with the Twitter Streaming API (with OAuth!)

## Setup (just do this once)

Copy `config/oauth.yml.example` to `config/oauth.yml` and enter your OAuth details.

Then run:

```
bundle install
```

## Get tweets!!

```
bundle exec ruby stream.rb
```

## What do people want?

```
bundle exec ruby wants/map.rb | sort | bundle exec ruby wants/reduce.rb
```

## Who has the most @mentions?

```
bundle exec ruby mentions/map.rb | sort | bundle exec ruby mentions/reduce.rb
```
