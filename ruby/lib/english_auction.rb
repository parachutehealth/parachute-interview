# frozen_string_literal: true

# class to perform auction
class EnglishAuction
  def initialize(io)
    @io             = io
    @users          = []
    @bids           = []
    @current_high   = 0
    @current_winner = 'Nobody'
  end

  def start_auction
    # main method to initialize auction and decide the winner
    set_auction_members
    start_biding
    display_winner
  end

  private

  def set_auction_members
    # method to set auction members
    loop do
      @io.out 'Please Enter a User Name OR Enter Blank to End'
      user = @io.read.strip
      break if user.empty?

      @users.push user
      @io.out @users.last
    end
  end

  def start_biding
    # method to get bids from all users until they decide to pass
    loop do
      display_highest_bid
      user = @users.first
      @io.out "#{user}, enter a bid (0 to pass):"
      @users.push @users.shift

      user_bid = @io.read.to_i
      @bids.push(user_bid)
      break if auction_over?

      set_highest_bid(user_bid, user) if user_bid > @current_high
    end
  end

  def auction_over?
    # method to ensure all users have entered their bids and passed their turn
    return false unless @bids.length >= @users.length

    start = @users.length * -1
    recent_bids = @bids[start, @users.length]
    recent_bids.sum.zero?
  end

  def set_highest_bid(user_bid, user)
    # method to set winner of the auction
    @current_high = user_bid
    @current_winner = user
  end

  def display_winner
    # method to display the winner
    @io.out "Winner is #{@current_winner} with a bid of #{@current_high}"
  end

  def display_highest_bid
    # method to display highest bid at any moment
    @io.out "Current high bid is: #{@current_high} - #{@current_winner}"
  end
end
