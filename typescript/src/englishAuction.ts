export interface IO {
  read: () => Promise<string>,
  out: (prompt: string) => Promise<void>
}

interface UserBid {
  user: string
  bid: number
}

export class EnglishAuction {
  private io: IO
  private users: string[] = []
  private bids: UserBid[] = []

  constructor(io: IO) {
    this.io = io
  }

  async start_auction() {
    await this.io.out("Enter the name of the first user, or blank to end")
    let user = await this.io.read()
    this.users.push(user)
    while (true) {
      await this.io.out("Enter the name of the next user, or blank to end")
      user = await this.io.read()
      if (!user || user === "") {
        break;
      }
      this.users.push(user)
    }

    for (let currentUser of this.users) {
      await this.io.out(`${currentUser}, enter a bid:`)

      const bid = parseInt(await this.io.read())
      this.bids.push({ bid, user: currentUser })
    }

    const winner = this.get_winner()

    await this.io.out(`Winner is ${winner}`)
  }

  get_winner() {
    const sortedBids =  this.bids.sort((a, b) => b.bid - a.bid)
    const winnerBid = sortedBids[0]
    return winnerBid.user
  }

}
