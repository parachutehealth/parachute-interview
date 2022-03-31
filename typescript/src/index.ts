import {EnglishAuction, IO} from './englishAuction'
import readline from 'readline'

const reader = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
})
const IO: IO = {
    out: async (prompt) => console.log(prompt),
    read: async () => {
        return new Promise(resolve =>
        reader.question('', answer => resolve(answer)))
    },
    terminal: async () => {
        return new Promise(resolve =>
        reader.close()
    )}
}

const auction = new EnglishAuction(IO)
auction.start_auction()