# frozen_string_literal: true

require_relative '../lib/english_auction'
require_relative '../lib/input_output'

RSpec.describe EnglishAuction do
  describe 'an english auction' do
    let(:high_bid_prompt) { 'Current high bid is:' }
    let(:bid_input_prompt) { ', enter a bid (0 to pass):' }
    let(:input_string) { 'Please Enter a User Name OR Enter Blank to End' }

    it 'prompts for the list of users and print them back' do
      io = double(InputOutput)
      expect(io).to receive(:out).with(input_string).ordered
      allow(io).to receive(:read).and_return('Zell', 'Brian', '')
      allow(io).to receive(:out)
      expect(io).to receive(:out).with('Zell').ordered
      expect(io).to receive(:out).with(input_string).ordered
      expect(io).to receive(:out).with('Brian').ordered
      expect(io).to receive(:out).with(input_string).ordered
      main = EnglishAuction.new(io)
      main.start_auction
    end

    context 'after the contestants are entered' do
      it 'prints the current high bid' do
        io = double(InputOutput)
        allow(io).to receive(:read).and_return('Zell', 'Brian', '')
        allow(io).to receive(:out)
        expect(io).to receive(:out).with("#{high_bid_prompt} 0 - Nobody")
        main = EnglishAuction.new(io)
        main.start_auction
      end

      it 'prompts the first contestant to enter a bid' do
        io = double(InputOutput)
        allow(io).to receive(:read).and_return('Zell', 'Brian', '')
        allow(io).to receive(:out)
        expect(io).to receive(:out).with("Zell#{bid_input_prompt}")
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
        expect(io).to receive(:out).with("Zell#{bid_input_prompt}").twice
        expect(io).to receive(:out).with("Brian#{bid_input_prompt}")

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
            expect(io).to receive(:out).with("#{high_bid_prompt} 0 - Nobody").twice

            main = EnglishAuction.new(io)
            main.start_auction
          end
        end

        context 'when that bid is higher than the current high' do
          it 'displays that as the new high bid' do
            io = double(InputOutput)
            allow(io).to receive(:read).and_return('Zell', 'Brian', '', '3', '4', '0', '0')
            allow(io).to receive(:out)
            expect(io).to receive(:out).with("#{high_bid_prompt} 3 - Zell")
            expect(io).to receive(:out).with("#{high_bid_prompt} 4 - Brian")
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
            expect(io).to receive(:out).with("Zell#{bid_input_prompt}")
            expect(io).to receive(:out).with("#{high_bid_prompt} 3 - Zell").at_least(2).times

            main = EnglishAuction.new(io)
            main.start_auction
          end
        end

        context 'When both user enter same bid' do
          it 'shows the first user as winner' do
            io = double(InputOutput)
            allow(io).to receive(:read).and_return('Zell', 'Brian', '', '3', '3', '0', '0')
            allow(io).to receive(:out)
            expect(io).to receive(:out).with('Winner is Zell with a bid of 3')

            main = EnglishAuction.new(io)
            main.start_auction
          end
        end

        context 'When a user enters a negative bid' do
          it 'will discard that bid' do
            io = double(InputOutput)
            allow(io).to receive(:read).and_return('Zell', 'Brian', '', '3', '-3', '0', '0')
            allow(io).to receive(:out)
            allow(io).to receive(:out)
            expect(io).to receive(:out).with("#{high_bid_prompt} 3 - Zell").at_least(1).times
            main = EnglishAuction.new(io)
            main.start_auction
          end
        end

        context 'when both user passes invalid values' do
          it 'does not record the bid' do
            io = double(InputOutput)
            allow(io).to receive(:read).and_return('Zell', 'Brian', '', 'Dummy', 'Dummy')
            allow(io).to receive(:out)
            expect(io).to receive(:out).with("#{high_bid_prompt} 0 - Nobody").twice

            main = EnglishAuction.new(io)
            main.start_auction
          end
        end
      end
    end
  end
end
