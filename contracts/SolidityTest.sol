//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SolidityTest is ERC721, Ownable {
    using Counters for Counters.Counter;

    uint public constant PRICE = 1 ether / 10;
    uint public constant MAX_SUPPLY = 1000;
    uint public constant MAX_PER_TX = 5;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Test Token", "TT") {}
    
    function claim() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Couldn't claim Ethers");
    }

    function mint(uint256 amount) external payable {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "");
        require(amount != 0);
        require(MAX_PER_TX >= amount, "Max 5 tokens per transaction");
        require(msg.value >= (PRICE * amount), "insufficient fund");

        for(uint256 i = 0; i < amount; i++) {
            _tokenIdCounter.increment();
            _safeMint(msg.sender, _tokenIdCounter.current());
        }
    }

    function ownerOf(uint256 tokenId) public view virtual override(ERC721) returns (address) {
        return ERC721.ownerOf(tokenId);
    }
}
