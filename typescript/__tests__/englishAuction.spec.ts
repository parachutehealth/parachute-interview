import { EnglishAuction } from "../src/englishAuction"

describe("an english auction", () => {
  it("prompts for a list of users and prints them back", async () => {
    const io = {
      read: jest.fn()
                .mockResolvedValueOnce("Zell")
                .mockResolvedValueOnce("Brian")
                .mockResolvedValueOnce('')
                .mockResolvedValue('0'),
      out:  jest.fn()
    }

    const auction = new EnglishAuction(io)
    await auction.start_auction()

    expect(io.out).toHaveBeenNthCalledWith(1, "Enter the name of the first user, or blank to end")
    expect(io.out).toHaveBeenNthCalledWith(2, "Zell")
    expect(io.out).toHaveBeenNthCalledWith(3, "Enter the name of the next user, or blank to end")
    expect(io.out).toHaveBeenNthCalledWith(4, "Brian")
  })

  describe("after the contestants are entered", () => {
    it("prints the current high bid", async () => {
      const io = {
        read: jest.fn()
                  .mockResolvedValueOnce("Zell")
                  .mockResolvedValueOnce("Brian")
                  .mockResolvedValueOnce('')
                  .mockResolvedValue('0'),

        out:  jest.fn()
      }

      const auction = new EnglishAuction(io)
      await auction.start_auction()

      expect(io.out).toHaveBeenCalledWith('Current high bid is: 0 - Nobody')
    });
    it("prompts the first contestant to enter a bid", async () => {
      const io = {
        read: jest.fn()
                  .mockResolvedValueOnce("Zell")
                  .mockResolvedValueOnce("Brian")
                  .mockResolvedValueOnce('')
                  .mockResolvedValue('0'),

        out:  jest.fn()
      }

      const auction = new EnglishAuction(io)
      await auction.start_auction()

      expect(io.out).toHaveBeenCalledWith('Zell, enter a bid (0 to pass):')
    });
  })

  describe("asking for bids", () => {
    it("prompts the users for their bids", async () => {
      const io = {
        read: jest.fn()
                  .mockResolvedValueOnce("Zell")
                  .mockResolvedValueOnce("Brian")
                  .mockResolvedValueOnce('')
                  .mockResolvedValueOnce('3')
                  .mockResolvedValueOnce('0')
                  .mockResolvedValueOnce('0'),
        out:  jest.fn()
      }

      const auction = new EnglishAuction(io)
      await auction.start_auction()
      expect(io.out).toHaveBeenNthCalledWith(7, 'Zell, enter a bid (0 to pass):')
      expect(io.out).toHaveBeenNthCalledWith(9, 'Brian, enter a bid (0 to pass):')
      expect(io.out).toHaveBeenNthCalledWith(11, 'Zell, enter a bid (0 to pass):')
    });
  })
  describe("when all contestants pass", () => {
    it("ends the auction and prints the winner", async () => {
      const io = {
        read: jest.fn()
                  .mockResolvedValueOnce("Zell")
                  .mockResolvedValueOnce("Brian")
                  .mockResolvedValueOnce('')
                  .mockResolvedValueOnce('3')
                  .mockResolvedValueOnce('4')
                  .mockResolvedValueOnce('0')
                  .mockResolvedValueOnce('0'),
        out:  jest.fn(),
      }

      const auction = new EnglishAuction(io)
      await auction.start_auction()

      expect(io.out).toHaveBeenCalledWith('Winner is Brian with a bid of 4')
    });
  })
})
