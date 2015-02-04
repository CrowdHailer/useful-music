Useful Music
============

Application to sell tracks

### Requirements

Ecomerce cart

### Commands

> Migrate Up

> `sequel -m db/migrations postgres://localhost/useful_music_development`

### Middleware

##### Rack::MethodOverride
will use the _method field in a form to decide the http verb that the application will be shown
[link](http://stackoverflow.com/questions/5166484/sending-a-delete-request-from-sinatra)

### Scorched Comments

##### Render defaults
When inherited the default has references the parent hash rather than having its own copy.
This code will cause bugs in other controllers

```rb
render_defaults[:dir] << '/new_path'
```
Instead use

```rb
render_defaults[:dir] += '/home'
# OR
render_defaults[:dir] = render_defaults[:dir].clone + '/pieces'
```
