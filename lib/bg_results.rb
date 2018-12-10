require "connection_pool"
require "redis"

require "bg_results/version"
require "bg_results/batch"
require "bg_results/worker/sidekiq"

module BgResults
  def self.redis_pool
    @redis ||= ConnectionPool.new(size: 5, timeout: 5) { Redis.new }
  end

  def self.redis_pool= pool
    @redis = pool
  end

  def self.redis
    redis_pool.with do |redis|
      yield redis
    end
  end
end
