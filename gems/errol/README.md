# Errol

**Repository build on top of [sequel](http://sequel.jeremyevans.net/) to store simple data records.** Errol encourages a separation of concerns in the domain model of a system where data is persisted. It uses these extra components to include a default solution for paginating its records.

They key components are the *Repository* that is responsible for storing and retrieving *Records* in response to various *Inquiries*. Records are not the same as the bloated god objects of active record but should remain simple data stores. The responsibility of a record is representing a database row with domain friendly types, this means serialising data. Where the behaviour that is no longer represented on your model now belongs is dependant on the system. It is often worth having an object that wraps the data record to define extra behaviour as well as methods to save. Errol ships with an entity that can be used as a starting point for these objects.  



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'errol'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install errol

## Usage

Usage is best described by each of the components

### Inquiry
The inquiry object is simply a store of data that was sent with each inquiry plus an optional set of defaults. The repository assumes that a page and page_size is available when using the ability to paginate

```rb
class Posts
  class Inquiry < Errol::Inquiry
    default :order, :id
    default :page, 1
    default :page_size, 12
    default :published, true
  end
end

inquiry = Inquiry.new :page => 2
inquiry.page
# => 2
inquiry.published?
# => true
inquiry.other
# => raise DefaultValueUndefined
```

### Records
These are simply sequel models. there is no wrapper and you define them as sequel models

```rb
class Post
  class Record < Sequel::Model(:posts)
  end
end
```

### Repository
The repository contains all the records, instances of a repository contain a subset dependant on the inquiry, by default the inquiry will be used to paginate.

```rb
class Posts < Errol::Repository

  class << self
    # The repository needs to know what records it is storing
    def record_class
      Post::Record
    end

    # The repository needs to know how to build a requirments hash that may be empty into a inquiry containing defaults
    def inquiry(requirements)
      Posts::Inquiry.new(requirements)
    end
  end

  # This the odd part, the dataset method is called when returning data. This a custom method that allows arbitrarily complex manipulation of data using settings from the inquiry
  def dataset
    partial = raw_dataset
    partial = partial.order(inquiry.order)
    partial = partial.where(:published) if inquiry.published
    partial
  end
end

page = Posts.new
# First page of published posts ordered by id

page.first_page?
# => true

page.page_size
# => 12

page.each { |post| puts post }
# Outputs each of the posts on the page

# class methods also use an inquiry to filter data

Posts.each { |post| puts post }
# Outputs each published post in the dataset ordered by id

Posts.each(:published => false, :order => :created_at) { |post| puts post }
# Outputs each post in the database ordered by creation date

#if you want a filtered dataset which is not paginated pass false as the last argument
set = Posts.new({:order => :created_at}, false)
```

### Entity
Entities are an optional wrapper around the record objects. My personal criteria as to if can add something to my record is can this object still be represented by an open struct? This allows me to test my entities with Ostructs and see the data thats is pulled or pushed to them. Use a entity for anything else. Say we want a post intro which is the first 20 words of a post. *I often name my entities after the domain object and name space the record below them, this is because I never interact with the data record.*

```rb
# Without Errol::Entity
class Post
  def initialize(record)
    @record = record
  end

  attr_reader :record

  def intro
    body.split[' '][0, 3].join(' ') + '...'
  end

  def body
    record.body
  end

  def title
    record.title
  end

  def save
    Posts.save record
  end
end

# With Errol::Entity
class Customer < Errorl::Entity
  repository = Customers
  entry_accessor :title, :body

  def intro
    body.split[' '][0, 3].join(' ') + '...'
  end
end
```

If you are working with entities you might not want to have to keep wrapping records. The repository allows you to define a method for sending out and accepting entities.

```rb
class Posts < Errol::Repository
  class << self
    def dispatch(record)
      Post.new(record)
    end

    def receive(entity)
      entity.record
    end
  end
end
```

## Documentation

### Entity

**::entry_reader** `entity.entry_reader(*entries) => self`

defines reader access to entries on the record which is short hand for calling `entity.record.entry`

**::entry_writer** `entity.entry_writer(*entries) => self`

defines writer access to entries on the record which is short hand for calling `entity.record.entry = value`

**::boolean_query** `entity.boolean_query(*entries) => self`

defines query(appends '?' on method name) to entries on the record which is short hand for calling `!!entity.record.entry`

**::entry_accessor** `entity.entry_accessor(*entries) => self`

short hand for entry_reader and entry_writer for entries

**::boolean_accessor** `entity.boolean_accessor(*entries) => self`

short hand for boolean_query and entry_writer for entries

**#set** `entity.set(**attributes) => self`

sends each item in the hash to a method matching the key with argument of the value

**#save** `entity.save => self`

Submits itself to the declared repository for saving

**#destroy** `entity.destroy => self`

Submits itself to the declared repository for removal

**#refresh** `entity.refresh => self`

Submits itself to the declared repository to be refreshed

## Contributing

1. Fork it ( https://github.com/[my-github-username]/errol/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Upcoming
1. separate repository save method to insert and replace
2. method missing bang methods call normal method then save
3. raise error if entity initialised with nil?
4. Protect record access method. Problem is access is require by repository to run sql filtering
