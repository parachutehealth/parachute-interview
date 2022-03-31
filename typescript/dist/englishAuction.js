"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.EnglishAuction = void 0;
var FIRST_USER_NAME = "Enter the name of the first user, or blank to end";
var NEXT_USER_NAME = "Enter the name of the next user, or blank to end";
var NOBODY_BIDS = "Current high bid is: 0 - Nobody";
var CURRENT_WINNER = 'Nobody';
var ZERO_TO_PASS = 'enter a bid (0 to pass):';
var CURRENT_HIGH_BID = 'Current high bid is:';
var WINNER_IS = 'Winner is';
var WITH_BID = 'with a sealed-bid of';
var HIGH_SEALED_BID = "Current high sealed-bid is: 0 - Nobody";
var ZERO_PASS_SEALED = "enter a sealed-bid (0 to pass):";
var CURRENT_SEALED_BID = "Current high sealed-bid is:";
var EnglishAuction = /** @class */ (function () {
    function EnglishAuction(io) {
        this.users = [];
        this.bids = [];
        this.sealedBids = [];
        this.io = io;
    }
    EnglishAuction.prototype.start_auction = function () {
        return __awaiter(this, void 0, void 0, function () {
            var user, highBid, sealedHighBid, winner, currentUser, userBid, bid, currentUser, userBid, bid;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, this.io.out("" + FIRST_USER_NAME)];
                    case 1:
                        _a.sent();
                        return [4 /*yield*/, this.io.read()];
                    case 2:
                        user = _a.sent();
                        this.users.push(user);
                        _a.label = 3;
                    case 3:
                        if (!true) return [3 /*break*/, 7];
                        return [4 /*yield*/, this.io.out(user)];
                    case 4:
                        _a.sent();
                        return [4 /*yield*/, this.io.out("" + NEXT_USER_NAME)];
                    case 5:
                        _a.sent();
                        return [4 /*yield*/, this.io.read()];
                    case 6:
                        user = _a.sent();
                        if (!user || user === "") {
                            return [3 /*break*/, 7];
                        }
                        this.users.push(user);
                        return [3 /*break*/, 3];
                    case 7:
                        highBid = 0;
                        sealedHighBid = 0;
                        winner = "" + CURRENT_WINNER;
                        return [4 /*yield*/, this.io.out("" + NOBODY_BIDS)];
                    case 8:
                        _a.sent();
                        _a.label = 9;
                    case 9:
                        if (!true) return [3 /*break*/, 13];
                        currentUser = this.users[0];
                        return [4 /*yield*/, this.io.out(currentUser + ", " + ZERO_TO_PASS)];
                    case 10:
                        _a.sent();
                        this.users.push(this.users.shift() || '');
                        return [4 /*yield*/, this.io.read()];
                    case 11:
                        userBid = _a.sent();
                        if (!userBid || userBid === "") {
                            this.users.push(this.users.shift() || '');
                            return [3 /*break*/, 13];
                        }
                        bid = parseInt(userBid);
                        this.bids.push(bid);
                        if (bid > highBid) {
                            highBid = bid;
                            winner = currentUser;
                        }
                        return [4 /*yield*/, this.io.out(CURRENT_HIGH_BID + " " + highBid + " - " + winner)];
                    case 12:
                        _a.sent();
                        return [3 /*break*/, 9];
                    case 13: return [4 /*yield*/, this.io.out("" + HIGH_SEALED_BID)];
                    case 14:
                        _a.sent();
                        _a.label = 15;
                    case 15:
                        if (!true) return [3 /*break*/, 19];
                        currentUser = this.users[0];
                        return [4 /*yield*/, this.io.out(currentUser + ", " + ZERO_PASS_SEALED)];
                    case 16:
                        _a.sent();
                        this.users.push(this.users.shift() || '');
                        return [4 /*yield*/, this.io.read()];
                    case 17:
                        userBid = _a.sent();
                        if (this.auctionOver()) {
                            this.io.terminal();
                            return [3 /*break*/, 19];
                        }
                        bid = parseInt(userBid);
                        this.sealedBids.push(bid);
                        if (bid > sealedHighBid) {
                            sealedHighBid = bid;
                            winner = currentUser;
                        }
                        return [4 /*yield*/, this.io.out(CURRENT_SEALED_BID + " " + sealedHighBid + " - " + winner)];
                    case 18:
                        _a.sent();
                        return [3 /*break*/, 15];
                    case 19: return [4 /*yield*/, this.io.out(WINNER_IS + " " + winner + " " + WITH_BID + " " + sealedHighBid)];
                    case 20:
                        _a.sent();
                        return [2 /*return*/];
                }
            });
        });
    };
    EnglishAuction.prototype.auctionOver = function () {
        if (this.sealedBids.length <= this.users.length) {
            return false;
        }
        var lastRound = this.sealedBids.slice(-this.users.length);
        var sum = lastRound.reduce(function (total, nextBid) { return total + nextBid; }, 0);
        return sum === 0;
    };
    return EnglishAuction;
}());
exports.EnglishAuction = EnglishAuction;
//# sourceMappingURL=englishAuction.js.map