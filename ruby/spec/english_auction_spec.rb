# frozen_string_literal: true

require_relative '../lib/english_auction'
require_relative '../lib/input_output'

RSpec.describe EnglishAuction do
  describe 'an english auction' do
    it 'prompts for the list of users and print them back' do
      io = double(InputOutput)
      expect(io).to receive(:out).with('Enter the name of the first user, or blank to end').ordered
      allow(io).to receive(:read).and_return('Zell', 'Brian', '')
      allow(io).to receive(:out)
      expect(io).to receive(:out).with('Zell').ordered
      expect(io).to receive(:out).with('Enter the name of the next user, or blank to end').ordered
      expect(io).to receive(:out).with('Brian').ordered
      expect(io).to receive(:out).with('Enter the name of the next user, or blank to end').ordered
      main = EnglishAuction.new(io)
      main.start_auction
    end

    context 'after the contestants are entered' do
      it 'prints the current high bid' do
        io = double(InputOutput)
        allow(io).to receive(:read).and_return('Zell', 'Brian', '')
        allow(io).to receive(:out)
        expect(io).to receive(:out).with('Current high bid is: 0 - Nobody')
        main = EnglishAuction.new(io)
        main.start_auction
      end

      it 'prompts the first contestant to enter a bid' do
        io = double(InputOutput)
        allow(io).to receive(:read).and_return('Zell', 'Brian', '')
        allow(io).to receive(:out)
        expect(io).to receive(:out).with('Zell, enter a bid (0 to pass):')
        allow(io).to receive(:out)
        main = EnglishAuction.new(io)
        main.start_auction
      end
    end

    context 'asking for bids' do
      it 'prompts the users for their bids' do
        io = double(InputOutput)
        allow(io).to receive(:read).and_return('Zell', 'Brian', '', '3', '0', '0')
        allow(io).to receive(:out)
        expect(io).to receive(:out).with('Zell, enter a bid (0 to pass):').twice
        expect(io).to receive(:out).with('Brian, enter a bid (0 to pass):')

        main = EnglishAuction.new(io)
        main.start_auction
      end

      context 'when all contestants pass' do
        it 'ends the auction and prints the winner' do
          io = double(InputOutput)
          allow(io).to receive(:read).and_return('Zell', 'Brian', '', '3', '4', '0', '0')
          allow(io).to receive(:out)
          expect(io).to receive(:out).with('Winner is Brian with a bid of 4')

          main = EnglishAuction.new(io)
          main.start_auction
        end
      end

      context 'when a bid is entered' do
        context 'when it is a pass' do
          it 'does not record the bid' do
            io = double(InputOutput)
            allow(io).to receive(:read).and_return('Zell', 'Brian', '', '0', '0')
            allow(io).to receive(:out)
            expect(io).to receive(:out).with('Current high bid is: 0 - Nobody').twice

            main = EnglishAuction.new(io)
            main.start_auction
          end
        end

        context 'when that bid is higher than the current high' do
          it 'displays that as the new high bid' do
            io = double(InputOutput)
            allow(io).to receive(:read).and_return('Zell', 'Brian', '', '3', '4', '0', '0')
            allow(io).to receive(:out)
            expect(io).to receive(:out).with('Current high bid is: 3 - Zell')
            expect(io).to receive(:out).with('Current high bid is: 4 - Brian')
            main = EnglishAuction.new(io)
            main.start_auction
          end
        end
        context 'when it is lower than the current high' do
          it 'does not record the bid' do
            io = double(InputOutput)
            allow(io).to receive(:read).and_return('Zell', 'Brian', '', '3', '2', '0', '0')
            allow(io).to receive(:out)
            allow(io).to receive(:out)
            expect(io).to receive(:out).with('Zell, enter a bid (0 to pass):')
            expect(io).to receive(:out).with('Current high bid is: 3 - Zell').at_least(2).times

            main = EnglishAuction.new(io)
            main.start_auction
          end
        end
      end
    end
  end
end
