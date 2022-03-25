# frozen_string_literal: true
class EnglishAuction
  def initialize(io)
    @io = io
    @users = []
    @bids = []
    @current_high = 0
    @current_winner = 'Nobody'
  end

  def start_auction
    prepare_users
    do_bets
    @io.out "Winner is #{@current_winner} with a bid of #{@current_high}"
  end

  private

  def prepare_users
    @io.out 'Enter the name of the first user, or blank to end'
    loop do
      user = @io.read.strip
      break if user.empty?

      @users.push user
      @io.out @users.last
      @io.out 'Enter the name of the next user, or blank to end'
    end
  end

  def auction_over?
    return false unless @bids.length >= @users.length
    start = @users.length * -1
    recent_bids = @bids[start, @users.length]
    recent_bids.sum === 0
  end

  def do_bets
    print_current_high_bid
    loop do
      current_user = @users.shift
      @io.out "#{current_user}, enter a bid (0 to pass):"
      @users.push current_user

      current_bid = @io.read.to_i
      @bids.push(current_bid)
      break if auction_over?
      if current_bid > @current_high
        @current_high = current_bid
        @current_winner = current_user
      end
      print_current_high_bid
    end
  end

  def print_current_high_bid
    @io.out "Current high bid is: #{@current_high} - #{@current_winner}"
  end


end
