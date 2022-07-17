// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.14;

contract FroTo{    
    // event for payment terms
    event PaymentRequest(string invoice);

    /**
     * @dev Submit payment
     * @param invoice Lightning invoice
     */
    function newInvoice(string memory invoice) public  {
        emit PaymentRequest(invoice);
    }
}