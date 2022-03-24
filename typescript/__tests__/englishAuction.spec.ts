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
    expect(io.out).toHaveBeenNthCalledWith(2, "Enter the name of the next user, or blank to end")
  })

  describe("after the contestants are entered", () => {
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

      expect(io.out).toHaveBeenCalledWith('Zell, enter a bid:')
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
                  .mockResolvedValueOnce('0'),
        out:  jest.fn()
      }

      const auction = new EnglishAuction(io)
      await auction.start_auction()
      expect(io.out).toHaveBeenNthCalledWith(4, 'Zell, enter a bid:')
      expect(io.out).toHaveBeenNthCalledWith(5, 'Brian, enter a bid:')
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
                  .mockResolvedValueOnce('4'),
        out:  jest.fn(),
      }

      const auction = new EnglishAuction(io)
      await auction.start_auction()

      expect(io.out).toHaveBeenCalledWith('Winner is Brian')
    });
  })
})
