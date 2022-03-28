# frozen_string_literal: true

module Auction
  class Users < BaseService
    def initialize
      @users = []
    end

    def call
      add_user
      @users
    end

    private

    def add_user
      out 'Enter the name of the first user, or blank to end'
      loop do
        user = read.strip
        break if user.empty?

        @users.push user
        out @users.last
        out 'Enter the name of the next user, or blank to end'
      end
    end
  end
end
