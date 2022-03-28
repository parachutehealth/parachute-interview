# frozen_string_literal: true

module Auction
  class HighestBid < BaseService
    def initialize(users)
      @users = users
      @bids = []
    end

    def call
      get_highest_bid
    end

    private

    def get_highest_bid
      out 'Current high bid is: 0 - Nobody'
      current_high = 0
      current_winner = 'Nobody'
      loop do
        current_user = @users.first
        out "#{current_user}, enter a bid (0 to pass):"
        @users.push @users.shift

        current_bid = read.to_i
        @bids.push(current_bid)
        break if auction_over?

        if current_bid > current_high
          current_high = current_bid
          current_winner = current_user
        end
        out "Current high bid is: #{current_high} - #{current_winner}"
      end

      [current_high, current_winner]
    end

    def auction_over?
      return false unless @bids.length >= @users.length

      start = @users.length * -1
      recent_bids = @bids[start, @users.length]
      recent_bids.sum === 0
    end
  end
end
