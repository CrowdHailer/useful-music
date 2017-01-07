# Useful Music

Application to sell sheet music and associated audio tracks.

## Local Development

```sh
# Clone this repository
git clone git@github.com:CrowdHailer/useful-music.git
cd useful-music

# Start up the development environment
vagrant up
vagrant ssh
cd /vagrant

# Fetch Ruby dependencies
bundle

# Create databases
createdb useful_music_development
createdb useful_music_development
rake db:migrate:up
RACK_ENV=test rake db:migrate:up

# Fetch Elixir dependencies
mix deps.get

# Start elixir application with environment variables
<ENV>=<variables> iex -S mix
```

## Heroku Setup

Requires PostgreSQL, Elixir and Ruby.

*explaination assumes heroku CLI is installed and authenticated.*

```sh
# Create a new app with app name and remote name
heroku apps:create um-tmp --remote tmp

# Setup buildpacks
heroku buildpacks:set https://github.com/HashNuke/heroku-buildpack-elixir.git --remote tmp
heroku buildpacks:set heroku/ruby --remote tmp
heroku buildpacks --remote tmp
# === um-tmp Buildpack URLs
# 1. https://github.com/HashNuke/heroku-buildpack-elixir.git
# 2. heroku/ruby

# Create a new addon with postgesql
heroku addons:create heroku-postgresql:hobby-dev --remote tmp

# run migrations
heroku run --remote tmp 'rake db:migrate:up'

# Setup environment variables

# Push working branch to environment
# git pust <remote> <local-branch>:<remote-branch>
git pust tmp development:master
```

#### Notes

- [elixir build pack](https://github.com/HashNuke/heroku-buildpack-elixir)
- [instructions for multiple buildpacks](https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app)
- [instruction for installing elixir buildpack](http://www.phoenixframework.org/docs/heroku)

## Environment variables

#### Amazon
Needed for some tests
- S3_BUCKET_NAME
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

#### Bugsnag
- BUGSNAG_API_KEY

#### Email


## Checklist

- [ ] Filter pieces
- [ ] Search for piece
- [ ] View piece assets
- [ ] Add items to cart
- [ ] Change currency preferences
- [ ] View cart
- [ ] Create new user
- [ ] Login
- [ ] Edit account information
- [ ] Reset password
- [ ] Apply discount
- [ ] Checkout
- [ ] Review orders
- [ ] View licence
- [ ] Download assets

## Notes

### For Demo

- Create Order, autocomplete for free orders

### For Production

- csrf middleware
- html escape/ user data only?
- Paypal integration

### Nice to have

- password reset checks the token has not expired
- check the format of user names

- set signed url expiry to 60 minutes
- form validation on files, accept types
- single page info webform
- remove abandoned carts

- catalogue to destroy associated items when deleting piece
- Handle invalid content values or assume octet content. check RFC.
- paginate in SQL query
- save exchange rate to order

### Other
- Money package needs how to use in project and link to hex in README
- Money package not to have USD by default, majority are not USD.

# Gateway
maybe best to rename web to gateway but probably not gateway will be for API endpoint and www for web backend for front end

- https://github.com/TykTechnologies/tyk/blob/master/README.md
- https://auth0.com/blog/an-introduction-to-microservices-part-2-API-gateway/
- https://www.youtube.com/watch?v=ZYSOSYg6rT0&t=1206s
