# defmodule UM.Web.Orders do
#   # This controller should be part of the sales context.
#   # Not sure where the boundary between sales and sessions baskets lives.
#   # Maybe shopping basket and currency preference lives in catalogue
#   def handle_request(request = %{path: [], method: :GET}, _env) do
#     # This is under the shopping_basket urls
#     # check discount codes if invalid remove and redirect to same page with warning message
#   end
#   def handle_request(request = %{path: [], method: :POST}, _env) do
#     # fetch user from header id
#     :ok = ENV.fetch('SUSPEND_PAYMENTS', '').empty?
#     customer = UM.Web.request_user(request)
#     shopping_basket = UM.Web.request_shopping_basket(request)
#
#     basket = %{
#       purchases: [
#         %{quantity: 2, item: %{id: 1, initial_price: 122, subsequent_price: 222}}
#       ]
#     }
#     Sales.checkout(basket, %{DB: db, Notifications: notifications})
#   end
# end
