# frozen_string_literal: true

# Manage bids for an english auction
class EnglishAuction
  attr_accessor :users, :bids, :current_high, :current_winner

  DEFAULT_WINNER = 'Nobody'
  DEFAULT_BID = 0

  def initialize(io)
    @io = io
    @users = []
    @bids = []
    @current_high = DEFAULT_BID
    @current_winner = DEFAULT_WINNER
  end

  def start_auction
    read_user_names
    output_current_high_bid_message
    record_bids

    @io.out "Winner is #{current_winner} with a bid of #{current_high}"
  end

  private

  def auction_over?
    return false unless first_round_completed?

    start = users.length * -1
    bids[start, users.length].sum.zero?
  end

  def output_enter_user_message(user_type)
    @io.out "Enter the name of the #{user_type} user, or blank to end"
  end

  def read_user_names
    output_enter_user_message('first')

    loop do
      user_name = @io.read.strip
      break if user_name.empty?

      users.push user_name
      @io.out user_name
      output_enter_user_message('next')
    end
  end

  def record_bids
    loop do
      current_user = users.first
      @io.out "#{current_user}, enter a bid (0 to pass):"
      users.rotate! # send first user to back of queue

      current_bid = @io.read.to_i
      bids.push(current_bid)
      break if auction_over?

      process_bid(current_bid, current_user)
      output_current_high_bid_message
    end
  end

  def output_current_high_bid_message
    @io.out "Current high bid is: #{current_high} - #{current_winner}"
  end

  def process_bid(current_bid, current_user)
    return unless current_bid > current_high

    self.current_high = current_bid
    self.current_winner = current_user
  end

  def first_round_completed?
    bids.length >= users.length
  end
end
