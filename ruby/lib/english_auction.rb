# frozen_string_literal: true
class EnglishAuction
  def initialize(io)
    @io = io
    @users = []
    @bids = []
    @permissions = []
    @current_high=0
    @current_winner ='Nobody'
  end

  def start_auction
    # Get input of Users and add them in @users & @permissions
    add_users

    #Get bid amount for each user in @user array
    add_bid_amount
    
    #Get Bid amount and winner name and show depending on winner 
    show_winner
  end


  private


  def add_users
    @io.out 'Enter the name of the first user, or blank to end'
    loop do
      user = @io.read.strip
      break if user.empty?
      @io.out 'Do you want to hide Bid Amount (y/n)'
      permission = @io.read.strip
      
      unless  ["y", "Y", "n", "N"].include?(permission)
        @io.out 'Please respond in y or n'
        permission = @io.read.strip
      end

      @users.push user
      @permissions.push permission
      @io.out @users.last
      @io.out 'Enter the name of the next user, or blank to end'
    end
  end

  def show_winner
    if auction_over?
      @io.out "Winner is #{@current_winner} with a bid of #{@current_high}"
    else
      @io.out "Current high bid is: #{@current_high} - #{@current_winner}}"
    end
  end

  def add_bid_amount
    loop do
      current_user = @users.first
      current_permission = @permissions.first
      @io.out "#{current_user}, enter a bid (0 to pass):"
      @users.push @users.shift
      @permissions.push @permissions.shift
      current_bid = @io.read.to_i
      @bids.push(current_bid)

      break if auction_over? 
      
      # check if Bid is higher then make this user current winner
      if current_bid > @current_high.to_i
        @current_high = current_bid
        @current_high = 'undisclosed' unless  ["n", "N"].include?(current_permission)
        @current_winner = current_user
      end

      show_winner
    end
  end
  
  def auction_over?
    return false unless @bids.length >= @users.length
    start = @users.length * -1
    recent_bids = @bids[start, @users.length]
    recent_bids.sum === 0
  end

end
