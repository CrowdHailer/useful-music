Useful Music
============

Application to sell sheet music and associated audio tracks.

## Services

- The staging application is running at http://wks14007-staging.herokuapp.com/

## Usage

#### Clone the app


```
git clone git@github.com:CrowdHailer/useful-music.git
cd useful-music
```

#### Provision VM

```sh
vagrant up

vagrant ssh
```

#### Install Ruby Gem Dependencies

```sh
sudo apt-get install libxslt-dev libxml2-dev -y && export NOKOGIRI_USE_SYSTEM_LIBRARIES=1 && sudo gem install --verbose nokogiri

bundle
```
http://stackoverflow.com/questions/11663499/unable-to-install-nokogiri-in-ubuntu-12-04

http://www.nokogiri.org/tutorials/installing_nokogiri.html

#### Add Enviroment Variable

*Enviroment variables loaded with dotenv Gem*

```
touch .env
```

required

```
SESSION_SECRET_KEY=DUMMY
S3_BUCKET_NAME=DUMMY
AWS_ACCESS_KEY_ID=DUMMY
AWS_SECRET_ACCESS_KEY=DUMMY
PAYPAL_USERNAME=DUMMY
PAYPAL_PASSWORD=DUMMY
PAYPAL_SIGNATURE=DUMMY
MANDRILL_USERNAME=DUMMY
MANDRILL_APIKEY=DUMMY
```

#### Create Databases

```
createdb useful_music_development
createdb useful_music_test
```

#### Migrate Databases

```
rake db:migrate:up
RACK_ENV=test rake db:migrate:up
```

#### Run tests

```
rake test
```

### Run locally

```
# Start application server
shotgun

# Start SASS watch and compilation
rake sass:watch
```

### Class Diagram

http://yuml.me/edit/668b5dff
http://yuml.me/edit/230cf55f
http://yuml.me/bc67d93c

### Scheduled Tasks

use `rake schedule:clear_shopping_baskets` to clear all inactive shopping baskets

### Commands

> Migrate up  
> `sequel -m db/migrations postgres://localhost/useful_music_development`

> Migrate down
> `sequel -m db/migrations postgres://localhost/useful_music_development -M 0`

> Test  
> `rake test`

> Remove unused baskets
> ` basket_ids = Customers.all.map(&:shopping_basket).map(&:id)`
> `ShoppingBaskets.new.dataset.exclude(id: basket_ids).destroy`

### Middleware

##### Rack::MethodOverride
will use the _method field in a form to decide the http verb that the application will be shown
[link](http://stackoverflow.com/questions/5166484/sending-a-delete-request-from-sinatra)

### App Comments
Note Factorygirl lint checks be database creation and does not clean up. lint within test space

Note CarrierWave needs root set for url generation when saving to file. Gem could use better error currently unable to coerce nil to string. In app url handled by aws but root needed for testing

NOTE sequel constraints require new table. [link](http://sequel.jeremyevans.net/rdoc-plugins/files/lib/sequel/extensions/constraint_validations_rb.html). Unsure why greater than is missing

[List of EU countries](http://www23.statcan.gc.ca/imdb/p3VD.pl?Function=getVD&TVD=141329)

### Scorched Comments

##### Static files
In production static_dir is set to false. This is why stylesheets have trouble loading

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
