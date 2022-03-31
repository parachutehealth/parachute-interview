export interface IO {
  read: () => Promise<string>,
  out: (prompt: string) => Promise<void>
}

export class EnglishAuction {
  private io: IO
  private users: string[] = []
  private bids: number[] = []

  constructor(io: IO) {
    this.io = io
  }

  async start_auction() {
    let usersCheck = true;
    let user;

    while (usersCheck) {
      await this.io.out("Enter the name of the first user, or blank to end")
      user = await this.io.read();
      if ( !user || user === "" ) {
        break;
      }
      this.users.push(user);
      await this.io.out(user);

    }

    let highBid = 0;
    let winner = 'Nobody'
    let currentUser;
    let bid;

    while (true) {
      await this.io.out(`Current high bid is: ${highBid} - ${winner}`)
      currentUser = this.users[0]
      await this.io.out(`${currentUser}, enter a bid (0 to pass):`)
      this.users.push(this.users.shift() || '')
      bid = parseInt(await this.io.read())
      this.bids.push(bid)
      if ( this.auctionOver() ) break;

      if ( bid > highBid ) {
        highBid = bid
        winner = currentUser
      }
    }

    await this.io.out(`Winner is ${winner} with a bid of ${highBid}`)
  }

  private auctionOver() {
    if (this.bids.length < this.users.length) return false;

    const lastRound = this.bids.slice(-this.users.length)
    const sum = lastRound.reduce((total, nextBid) => total + nextBid, 0)
    return sum === 0
  }

}
