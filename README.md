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

- Check basket creation and viewing. Admin view of baskets
- Discounts pages
- Create Order, autocomplete for free orders
- Admin views for order and and shopping baskets
- Check customer pages, view order
- Deployment
- Paypal integration
- Bug tracking

### For Production

- form validation on files, accept types
- encrypt password in db
- csrf middleware
- html escape

### Nice to have

- add items to public piece show page test
- all prices are in pence lookup money package
- paginate in SQL query
- Message for failed to delete item because of purchases
- admin controller redirects to login page if needed
- search results have page hardcoded, i.e. loose search on next page (already happens)
- move all session helpers from the public router
- setting purchase items to zero
- customer can edit only their own basket

- adding no items to basket is silly (currently the case)
- check the format of user names
- catalogue to destroy associated items when deleting piece
- solution to stringifying keys in admin/pieces_controller_test
  `piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}``
- Minimise validation on piece_form so we can use meaningful db exceptions
  OR Add field errors from the form.
- random pieces are hardcoded to 4


```elixir
Try.for do
  form <- Map.fetch(body, "customer")
  data <- ChangePasswordForm.validate
  %{id: id} <- Accounts.change_password(customer, data)
end
```
# Gateway
maybe best to rename web to gateway but probably not gateway will be for API endpoint and www for web backend for front end

- https://github.com/TykTechnologies/tyk/blob/master/README.md
- https://auth0.com/blog/an-introduction-to-microservices-part-2-API-gateway/
- https://www.youtube.com/watch?v=ZYSOSYg6rT0&t=1206s

# Sessions
This might not be a separate app but live in the API gateway.
I like the idea of writing the session to headers which are then passed downstream,
downstream units are equivalently controllers/services.

login

logout

# Accounts
Quite closely linked to session

signup,

answer questionare, change password, reset password, all edit account

# Catalogue

create piece,

edit piece,

add item,

# Sales
create basket, use session ID, do not save if empty, relies on logging out to clear session otherwise two baskets one session. idea bellow session might be machine or browser. could delegate to ip

update basket, add item or items to basket with quantity

add discount

remove discount

If session user has basket overrides session basket.
dont do this.
merge baskets, needed when a user with items in session basket logs in.

start paypal checkout, paypal existing as a kind of billing domain. refunds need to be marked manually.

succeed checkout

cancel checkout

view create licence/invice

clear inactive baskets, same as clear inactive sessions, not nice in Event stored system

manage discounts?
