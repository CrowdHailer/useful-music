# RENAME cart
# Customer doesn't have basket inside, use id and then keep data in session.
# Similar behaviour for discount

web depends on all
accounts depends on all except web
sales depends on catalogue

Useful Music
============

Application to sell sheet music and associated audio tracks.

## Installation

```sh
# Clone this repository
git clone git@github.com:CrowdHailer/useful-music.git
cd useful-music

# start up the development environment
vagrant up
vagrant ssh
```

## Development

This is a migration of a Ruby project to an elixir project.
Ruby code will only be deleted once the functionality has been migrated.

## Production

Hosted on a heroku environment.
Requires a database as well as elixir AND ruby build packs.

- [elixir build pack](https://github.com/HashNuke/heroku-buildpack-elixir)
- [instructions for multiple buildpacks](https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app)
- [instruction for installing elixir buildpack](http://www.phoenixframework.org/docs/heroku)


Had to stop using subdirectory for elixir project.
Using a [subtree](https://sndrs.ca/2013/11/15/deploy-a-subdirectory-to-heroku-as-an-app/) was a possible alternative

## Notes

### For Demo

- Create Order, autocomplete for free orders

### For Production

- mailers
- encrypt password in db
- csrf middleware
- html escape
- Paypal integration

### Nice to have

- set signed url expiry to 60 minutes
- sort items in shopping basket by piece id
- form validation on files, accept types
- password reset checks the token has not expired
- single page info webform
- save exchange rate to order
- all prices are in pence lookup money package
- paginate in SQL query
- Message for failed to delete item because of purchases
- change password page shows form errors
- remove abandoned carts

- check the format of user names
- catalogue to destroy associated items when deleting piece
- solution to stringifying keys in admin/pieces_controller_test
  `piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}``
- Minimise validation on piece_form so we can use meaningful db exceptions
  OR Add field errors from the form.
- random pieces are hardcoded to 4
- generate styles from asset files
- use relative links in templates
- Handle invalid content values or assume octet content. check RFC.
- create piece tests, generalise form, push upload content to db.

```elixir
Try.for do
  data <- ChangePasswordForm.validate
  %{id: id} <- Accounts.change_password(customer, data)
end
```
# Gateway
maybe best to rename web to gateway but probably not gateway will be for API endpoint and www for web backend for front end

- https://github.com/TykTechnologies/tyk/blob/master/README.md
- https://auth0.com/blog/an-introduction-to-microservices-part-2-API-gateway/
- https://www.youtube.com/watch?v=ZYSOSYg6rT0&t=1206s
