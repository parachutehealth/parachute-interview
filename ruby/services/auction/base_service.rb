# frozen_string_literal: true

module Auction
  class BaseService
    def self.call(*arg)
      new(*arg).call
    end

    def out(string)
      $stdout.puts string
    end

    def read
      $stdin.gets
    end
  end
end
