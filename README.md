# ActiveRecordAssociatedJsonb

[![Codeship Status for dipil-saud/activerecord-associated-jsonb](https://app.codeship.com/projects/20aaa450-bcca-0136-b9cd-4a53bd4c8e4c/status?branch=master)](https://app.codeship.com/projects/312783)

The activerecord-jsonb-gem augments ActiveRecord's attribute API to allow accessing and updating data stored in jsonb columns as AR models.
It allows using validations on the embedded record and tracks changes.

Currently only supports postgres jsonb columns.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-associated-jsonb', github: 'dipil-saud/activerecord-associated-jsonb'
```

And then execute:

    $ bundle

## Example Usage

```ruby
  require 'active_record_associated_jsonb'

  class Address < ActiveRecordAssociatedJsonb::Record
    attribute :line1
    attribute :line2
    attribute :city
    attribute :zip_code, type: :integer
    attribute :country, default: 'US'

    ##### VALIDATIONS #####
    validates :line1,
      :city,
      :zip_code,
      :country,
      presence: true
    validates :zip_code, :format => /\A\d{5}(-\d{4})?\z/
  end

  class User < ActiveRecord::Base
    attribute :addresses, ActiveRecordAssociatedJsonb::Type.new(child_class: Address)
  end

  # create a user with addresses
  u = User.new(addresses: { line1: '...', zip_code: '...' ..}])

  # or
  u = User.new
  a = Address.new({ line1: ... })
  u.addresses << a

  a.valid?
  a.errors # shows details for each address attribute

  u.valid?
  u.errors # only shows addresses is invalid like it would for has_many relation
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activerecord-associated-jsonb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activerecord::Associated::Jsonb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/activerecord-associated-jsonb/blob/master/CODE_OF_CONDUCT.md).
