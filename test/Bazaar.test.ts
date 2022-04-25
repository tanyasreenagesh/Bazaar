import { Signer } from "ethers";
import { ethers } from "hardhat";
import { Bazaar, Bazaar__factory } from "../typechain";

const CONTRACT_INV_FRIENDS = "0x59468516a8259058baD1cA5F8f4BFF190d30E066";

const TOKENID_1 = 1;
const PRICE_1 = 0;

const TOKENID_2 = 5;
const PRICE_2 = 3;

describe("Bazaar Tests", () => {
    let instance: Bazaar;
    let accounts: Signer[];
    let defaultSigner: Signer;

    beforeEach(async () => {
        accounts = await ethers.getSigners();
        defaultSigner = accounts[0];

        const factory = new Bazaar__factory(defaultSigner);
        instance = await factory.deploy();

        const balance = await defaultSigner.getBalance();
        const balanceAsString = ethers.utils.formatUnits(balance, 18)
        console.log("Account balance = ", balanceAsString);
    });

    it('Should publish a piece to the Bazaar', async () => {
        await instance.publishPiece(CONTRACT_INV_FRIENDS, TOKENID_1, PRICE_1);

        const pieces = await instance.getAllPiecesOnSale();
        console.log("All pieces on sale:", pieces);
    });

    it('Should publish more than one piece to the Bazaar', async () => {
        await instance.publishPiece(CONTRACT_INV_FRIENDS, TOKENID_1, PRICE_1);
        await instance.publishPiece(CONTRACT_INV_FRIENDS, TOKENID_2, PRICE_2);

        const pieces = await instance.getAllPiecesOnSale();
        console.log("All pieces on sale:", pieces);
    });

    it('Should buy piece with tokenID=1 from the Bazaar', async () => {
        await instance.publishPiece(CONTRACT_INV_FRIENDS, TOKENID_1, PRICE_1);
        await instance.publishPiece(CONTRACT_INV_FRIENDS, TOKENID_2, PRICE_2);
        await instance.buyPiece(TOKENID_1);

        const pieces = await instance.getAllPiecesOnSale();
        console.log("All pieces on sale:", pieces);

        const pieceBought = await instance.allPieces(TOKENID_1);
        console.log("Piece bought:", pieceBought);
    });
})