# frozen_string_literal: true

require_relative '../lib/english_auction'
require_relative '../lib/input_output'

RSpec.describe EnglishAuction do
  def start(io)
    main = EnglishAuction.new(io)
    main.start_auction
  end

  def prepare_users(io, users)
    prepare_inputs(io, *users, '')
  end

  def prepare_inputs(io, *inputs)
    allow(io).to receive(:read).and_return(*inputs)
    allow(io).to receive(:out)
  end

  def should_asks_for_user_and_show(io, users)
    expect(io).to receive(:out).with('Enter the name of the first user, or blank to end').ordered
    prepare_users(io, users)
    should_show_users(io, users)
  end

  def should_show_users(io, users)
    users.each do |user|
      expect(io).to receive(:out).with(user).ordered
      expect(io).to receive(:out).with('Enter the name of the next user, or blank to end').ordered
    end
  end

  describe 'an english auction' do
    context 'prompts for the list of users and print them back' do
      it 'when 2 users' do
        io = double(InputOutput)
        should_asks_for_user_and_show(io, %w[Zell Brian])

        start(io)
      end
      it 'when 3 users' do
        io = double(InputOutput)
        should_asks_for_user_and_show(io, %w[Zell Brian JB])

        start(io)
      end
      it 'when 4 users' do
        io = double(InputOutput)
        should_asks_for_user_and_show(io, %w[Zell Brian JB NoJB])

        start(io)
      end
    end

    context 'after the contestants are entered' do
      it 'prints the current high bid' do
        io = double(InputOutput)
        prepare_users(io, %w[Zell Brian])
        expect(io).to receive(:out).with('Current high bid is: 0 - Nobody')

        start(io)
      end

      it 'prompts the first contestant to enter a bid' do
        io = double(InputOutput)
        prepare_users(io, %w[Zell Brian])
        expect(io).to receive(:out).with('Zell, enter a bid (0 to pass):')

        start(io)
      end
    end

    context "asking for bids" do
      it "prompts the users for their bids" do
        io = double(InputOutput)
        prepare_inputs(io, 'Zell', 'Brian', '', '3', '0', '0')
        expect(io).to receive(:out).with('Zell, enter a bid (0 to pass):').twice
        expect(io).to receive(:out).with('Brian, enter a bid (0 to pass):')

        start(io)
      end

      context "when all contestants pass" do
        it "ends the auction and prints the winner" do
          io = double(InputOutput)
          prepare_inputs(io, 'Zell', 'Brian', '', '3', '4', '0', '0')
          expect(io).to receive(:out).with('Winner is Brian with a bid of 4')

          start(io)
        end
      end

      context 'when a bid is entered' do
        context 'when it is a pass' do
          it 'does not record the bid' do
            io = double(InputOutput)
            prepare_inputs(io, 'Zell', 'Brian', '', '0', '0')
            expect(io).to receive(:out).with('Current high bid is: 0 - Nobody').twice

            start(io)
          end
        end

        context 'when that bid is higher than the current high' do
            it 'displays that as the new high bid' do
              io = double(InputOutput)
              prepare_inputs(io, 'Zell', 'Brian', '', '3', '4', '0', '0')
              expect(io).to receive(:out).with('Current high bid is: 3 - Zell')
              expect(io).to receive(:out).with('Current high bid is: 4 - Brian')
              start(io)
            end
          end
        context "when it is lower than the current high" do
          it "does not record the bid" do
            io = double(InputOutput)
            prepare_inputs(io, 'Zell', 'Brian', '', '3', '2', '0', '0')
            expect(io).to receive(:out).with('Zell, enter a bid (0 to pass):')
            expect(io).to receive(:out).with('Current high bid is: 3 - Zell').at_least(2).times

            start(io)
          end
        end
      end
    end
  end
end
