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

merge baskets, needed when a user with items in session basket logs in.

start paypal checkout, paypal existing as a kind of billing domain. refunds need to be marked manually.

succeed checkout

cancel checkout

view create licence/invice

clear inactive baskets, same as clear inactive sessions, not nice in Event stored system

manage discounts?
