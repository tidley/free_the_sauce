// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Inter is Ownable {
    string invoice;

    event Invoice(string _invoice);

    function store(string memory _invoice) public {
        invoice = _invoice;
        emit Invoice(invoice);
    }

    function retrieve() public view returns (string memory) {
        return invoice;
    }
}
