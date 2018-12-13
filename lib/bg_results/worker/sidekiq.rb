module BgResults
  module Worker
    module Sidekiq
      def perform *args
        result = super
        if bid && jid
          data = {result: result}.to_json
          BgResults.redis do |conn|
            conn.hset "RESULTS-#{bid}", jid, data
          end
        end
      end
    end
  end
end
