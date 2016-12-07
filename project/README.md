# TODO

- form validation on files
- csrf middleware
- html escape
- all prices are in pence lookup money package
- Message for failed to delete item because of purchases

- catalogue to destroy associated items when deleting piece
- solution to stringifying keys in admin/pieces_controller_test
  `piece = for {k, v} <- piece, into: %{}, do: {"#{k}", v}``
- Minimise validation on piece_form so we can use meaningful db exceptions
  OR Add field errors from the form.

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
