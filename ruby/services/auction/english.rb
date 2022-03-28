# frozen_string_literal: true

module Auction
  class English < BaseService
    def initialize; end

    def call
      start_auction
    end

    private

    def start_auction
      users = Auction::Users.call
      highest_bid, winner = Auction::HighestBid.call(users)
      out "Winner is #{winner} with a bid of #{highest_bid}"
    end
  end
end
