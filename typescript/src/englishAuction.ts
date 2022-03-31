export interface IO {
  read: () => Promise<string>,
  out: (prompt: string) => Promise<void>,
  terminal: () => Promise<void>,
}

const FIRST_USER_NAME   = "Enter the name of the first user, or blank to end"
const NEXT_USER_NAME    = "Enter the name of the next user, or blank to end"
const NOBODY_BIDS       = "Current high bid is: 0 - Nobody"
const CURRENT_WINNER    = 'Nobody'
const ZERO_TO_PASS      = 'enter a bid (0 to pass):'
const CURRENT_HIGH_BID  = 'Current high bid is:'
const WINNER_IS         = 'Winner is'
const WITH_BID          = 'with a sealed-bid of'
const HIGH_SEALED_BID   = "Current high sealed-bid is: 0 - Nobody"
const ZERO_PASS_SEALED  = "enter a sealed-bid (0 to pass):"
const CURRENT_SEALED_BID= "Current high sealed-bid is:"

export class EnglishAuction {
  private io: IO
  private users: string[] = []
  private bids: number[] = []
  private sealedBids: number[] = []

  constructor(io: IO) {
    this.io = io
  }

  async start_auction() {
    await this.io.out(`${FIRST_USER_NAME}`)
    let user = await this.io.read()
    this.users.push(user)
    while (true) {
      await this.io.out(user)
      await this.io.out(`${NEXT_USER_NAME}`)
      user = await this.io.read()
      if ( !user || user === "" ) {
        break;
      }
      this.users.push(user)
    }

    let highBid = 0;
    let sealedHighBid = 0;
    let winner = `${CURRENT_WINNER}`
    await this.io.out(`${NOBODY_BIDS}`)

    while (true) {
      const currentUser = this.users[0]
      await this.io.out(`${currentUser}, ${ZERO_TO_PASS}`)
      this.users.push(this.users.shift() || '')
      const userBid = await this.io.read()
      
      if ( !userBid || userBid === "" ) {
        this.users.push(this.users.shift() || '')
        break
      }
      const bid = parseInt(userBid)
      this.bids.push(bid)
      if ( bid > highBid ) {
        highBid = bid
        winner = currentUser
      }

      await this.io.out(`${CURRENT_HIGH_BID} ${highBid} - ${winner}`)
    }

    await this.io.out(`${HIGH_SEALED_BID}`)
    while (true) {
      const currentUser = this.users[0]
      await this.io.out(`${currentUser}, ${ZERO_PASS_SEALED}`)
      this.users.push(this.users.shift() || '')
      const userBid = await this.io.read()
      if ( this.auctionOver() ) {
        this.io.terminal();
        break
      }
      const bid = parseInt(userBid)
      this.sealedBids.push(bid)
      if ( bid > sealedHighBid ) {
        sealedHighBid = bid
        winner = currentUser
      }
      await this.io.out(`${CURRENT_SEALED_BID} ${sealedHighBid} - ${winner}`)
    }

    await this.io.out(`${WINNER_IS} ${winner} ${WITH_BID} ${sealedHighBid}`)
  }

  private auctionOver() {
    if ( this.sealedBids.length <= this.users.length ) {
      return false;
    }
    const lastRound = this.sealedBids.slice(-this.users.length)
    const sum = lastRound.reduce((total, nextBid) => total + nextBid, 0)
    return sum === 0
  }

}
