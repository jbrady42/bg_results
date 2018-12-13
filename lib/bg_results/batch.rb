module BgResults
  class Batch
    RESULT_TTL = 86400 # 1 day
    def initialize bid
      @bid = bid
      @key = "RESULTS-#{@bid}"
    end

    def results
      data, _ = BgResults.redis do |conn|
        conn.multi do
          conn.hgetall @key
          conn.expire @key, RESULT_TTL
        end
      end
      parse_results data
    end

    def results_in_batches
      count = 100
      cursor = 0
      loop do
        cursor, data = scan cursor, count
        data = parse_results data.to_h
        yield data
        break if cursor == 0
      end
      set_results_expire
    end

    def results_each
      return unless block_given?
      results_in_batches do |batch|
        batch.each do |jid, res|
          yield jid, res
        end
      end
    end

    def set_results_expire exp=RESULT_TTL
      BgResults.redis do |conn|
        conn.expire @key, exp
      end
    end

    def clear_results!
      BgResults.redis do |conn|
        conn.del @key
      end
    end

  private
    def scan cursor, count
      new_cursor, data = BgResults.redis do |conn|
        conn.hscan @key, cursor, count: count
      end
      [new_cursor.to_i, data]
    end

    def parse_results data
      data = data.transform_values do |v|
        payload = JSON.parse v
        payload["result"]
      end
    end
  end
end
