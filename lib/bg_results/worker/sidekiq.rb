module BgResults
  module Worker
    module Sidekiq
      def perform *args
        result = super
        if batch = bid&.bid
          BgResults.redis do |conn|
            conn.hset "RESULTS-#{batch}", jid, result
          end
        end
      end
    end
  end
end
