defmodule Raxx.Flash do
  # Flash can be headers because it is
  # > Since each endpoint REpresents a State Transfer (to mangle the mnemonic), custom headers should only be used for things that don't involve the name of the resource (the url), the state of the resource (the body), or parameters directly affecting the resource (parameters). That leaves true metadata about the request for custom headers.
  # flash is metadata about the request.
  # it effects the returned page but that is not a representation of the resource
  def read_messages(%{query: _q}) do
    # uri decode should be handled
    # poison decode should be used or another uri decode layer
  end
  # this layer as a wall
end

# testing the stack
# method overwrite
