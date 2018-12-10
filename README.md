# BgResults

A simple tool for collecting results from background job batches.
Results returned from the jobs are stored in a redis hash. The

Currently Sidekiq is supported using the 3rd part batch gem, but it should work with Sidekiq pro as well. Worker modules for other queue systems can be easily added to support different providers.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bg_results'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bg_results

## Usage


### Workers
To enable results in a sidekiq worker `prepend BGResults::Worker::Sidekiq`
```
class ResultsJob
  include Sidekiq::Worker
  prepend BGResults::Worker::Sidekiq

  def perform
    result = background_task
  end
end
```

###  Collect results
Use the results batch object to access background results in the batch callbacks. Results are identified by batch_id.

```
def on_success status, options
  batch_res = BGResults::Batch.new status.bid
end
```
**NOTE:** accessing results is a destructive action. Results will be cleared from redis on first access

#### All in one
Return all results in a hash with mapping `{job_id => result}`.

```
results = batch_res.results
```
#### Scan
Collect results in batches with redis scan.
```
res.results_each do |job_id, result|
  puts result
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bg_results.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
