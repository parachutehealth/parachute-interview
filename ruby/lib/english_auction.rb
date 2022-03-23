# frozen_string_literal: true
class EnglishAuction
  def initialize(io)
    @io = io
    @users = []
    @bids = []
  end

  def start_auction
    @io.out 'Enter the name of the first user, or blank to end'

    loop do
      user = @io.read.strip
      break if user.empty?

      @users.push user
      @io.out @users.last
      @io.out 'Enter the name of the next user, or blank to end'
    end

    @io.out 'Current high bid is: 0 - Nobody'
    current_high = 0
    current_winner = 'Nobody'
    loop do
      current_user = @users.first
      @io.out "#{current_user}, enter a bid (0 to pass):"
      @users.push @users.shift

      current_bid = @io.read.to_i
      @bids.push(current_bid)
      break if auction_over?
      if current_bid > current_high
        current_high = current_bid
        current_winner = current_user
      end
      @io.out "Current high bid is: #{current_high} - #{current_winner}"
    end

    @io.out "Winner is #{current_winner} with a bid of #{current_high}"
  end

  private

  def auction_over?
    return false unless @bids.length >= @users.length
    start = @users.length * -1
    recent_bids = @bids[start, @users.length]
    recent_bids.sum === 0
  end
end
