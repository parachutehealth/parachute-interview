# frozen_string_literal: true
class EnglishAuction
  # Here we are defining constants string
  FIRST_USER_NAME  = 'Enter the name of the first user, or blank to end'
  NEXT_USER_NAME   = 'Enter the name of the next user, or blank to end'
  NOBODY_BIDS      = 'Current high bid is: 0 - Nobody'
  CURRENT_WINNER   = 'Nobody'
  ZERO_TO_PASS     = 'enter a bid (0 to pass):'
  CURRENT_HIGH_BID = 'Current high bid is:'
  WINNER_IS        = 'Winner is'
  WITH_BID         = 'with a bid of'

  def initialize(io)
    @io = io
    @users = []
    @bids = []
  end

  def start_auction
    @io.out FIRST_USER_NAME
    
    # Get User's Name Input 
    get_users_list

    @io.out NOBODY_BIDS
    current_high = 0
    current_winner = CURRENT_WINNER

    # Get User's Bids Input
    current_winner, current_high = get_bids_list(current_winner, current_high)

    @io.out "#{WINNER_IS} #{current_winner} #{WITH_BID} #{current_high}"
  end

  def get_bids_list current_winner, current_high
    loop do
      current_user = @users.first
      @io.out "#{current_user}, #{ZERO_TO_PASS}"
      @users.push @users.shift

      current_bid = @io.read.to_i
      @bids.push(current_bid)
      break if auction_over?
      if current_bid > current_high
        current_high = current_bid
        current_winner = current_user
      end
      @io.out "#{CURRENT_HIGH_BID} #{current_high} - #{current_winner}"
    end
    return current_winner, current_high
  end

  def get_users_list
    loop do
      user = @io.read.strip
      break if user.empty?

      @users.push user
      @io.out @users.last
      @io.out NEXT_USER_NAME
    end
  end

  private

  def auction_over?
    return false unless @bids.length >= @users.length
    start = @users.length * -1
    recent_bids = @bids[start, @users.length]
    recent_bids.sum === 0
  end
end
