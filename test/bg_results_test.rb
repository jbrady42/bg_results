require "test_helper"

class BgResultsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BgResults::VERSION
  end

  def test_it_does_something_useful
    ::BgResults::Worker::Sidekiq
    ::BgResults::Batch.new 2
    assert false
  end
end
