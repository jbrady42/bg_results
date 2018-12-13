require "test_helper"

class BgResultsTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::BgResults::VERSION
  end

  def test_it_does_not_blow_up
    ::BgResults::Worker::Sidekiq
    ::BgResults::Batch.new 2
    assert true
  end

  def test_it_passes_hash
    # Do work
    job = ResultsTestJob.new 1
    job.perform

    # Check results
    batch_res = BgResults::Batch.new job.bid
    results = batch_res.results

    # Comes out the other side with string keys
    # Preserves numeric types
    assert results.values.first == {"the_answer" => 42}
  end
end


class ResultsTestJob
  prepend BgResults::Worker::Sidekiq
  attr_reader :bid, :jid

  def initialize bid
    @bid = bid
    @jid = rand 10000
  end

  def perform
    {the_answer: 42}
  end
end
