//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// 0x59468516a8259058baD1cA5F8f4BFF190d30E066

/*
TODO: Fork mainnet to be used in tests for existing NFT contracts.
TODO: Index by contract address and token ID to avoid dups.
*/

contract Bazaar {
    using Counters for Counters.Counter;

    address bazaarOwner;
    Counters.Counter private pieceCount;
    Counters.Counter private onSalePieceCount;
    Counters.Counter private soldPieceCount;

    /* 
    pieces:
        listed
        sold
    */
    struct Piece {
        uint256 pieceID;
        address contractAddy;
        uint256 tokenID;
        uint256 price;
        address payable seller;
        address payable owner;
        bool isSold;
    }

    mapping(uint256 => Piece) public allPieces;

    event PiecePublished(address _seller, address _contractAddy, uint256 _tokenID, uint256 _price);
    event PieceBought(address _newOwner, address _contractAddy, uint256 _tokenID, uint256 _price);

    /*
    TODO: Write events for logging.
    */
    constructor() {
        bazaarOwner = msg.sender;
    }

    /*
    publishPiece:
        Takes a contract address and tokenID as parameters
        and publishes the NFT to the bazaar.
    TODO: Emit IERC721 transfer event.
    TODO: Add publishing fee.
    TODO: Pay the Bazaar owner.
    */
    function publishPiece(address _contractAddy, uint256 _tokenID, uint256 _price) payable public {
        pieceCount.increment();
        onSalePieceCount.increment();
        
        allPieces[pieceCount.current()] = Piece({
            pieceID: pieceCount.current(),
            contractAddy: _contractAddy,
            tokenID: _tokenID,
            price: _price,
            seller: payable(msg.sender),
            owner: payable(address(0)),
            isSold: false
        });

        emit PiecePublished(msg.sender, _contractAddy, _tokenID, _price);
    }

    /*
    buyPiece:
        Takes a pieceID as input and transfers NFT
        from seller to new owner.
    TODO: Emit IERC721 transfer event.
    TODO: Transfer the ERC721 token to msg.sender.
    */
    function buyPiece(uint256 _pieceID) payable public {
        Piece storage toSell = allPieces[_pieceID];
        require(msg.value >= toSell.price, "Not enough ETH to complete tx!");
        require(toSell.isSold == false, "This NFT is not for sale!");
        
        toSell.seller.transfer(msg.value);
        toSell.owner = payable(msg.sender);
        toSell.isSold = true;

        emit PieceBought(msg.sender, toSell.contractAddy, toSell.tokenID, toSell.price);

        onSalePieceCount.decrement();
        soldPieceCount.increment();
    }

    /*
    getAllPiecesOnSale:
        Returns an array of type Piece containing
        only the pieces currently on sale.
    */
    function getAllPiecesOnSale() public view returns (Piece[] memory) {
        Piece[] memory piecesOnSale = new Piece[](onSalePieceCount.current());
        uint256 curr = 0;

        for(uint i=1; i <= pieceCount.current(); ++i) {
            if (!allPieces[i].isSold) {
                piecesOnSale[curr] = allPieces[i];
                curr = curr+1;
            }
        }

        return piecesOnSale;
    }
}