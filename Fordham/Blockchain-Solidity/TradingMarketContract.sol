// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0; 

contract TradingMarketContract {

    mapping(uint8 => Stored_item) public items;
    address public market_owner;
    
    struct Stored_item {
        uint8 item_id;
        uint selling_price;
        address payable seller;
        bool available;
    }

    constructor() {
        market_owner = msg.sender; // owner of this market
    }

    function sell(uint8 item_id, uint price) public {
        require(item_id > 0, "Item ID must be greater than 0.");
        require(price > 0, "Price must be greater than 0.");
        require(items[item_id].seller == address(0), "Item ID already exists. Try inserting another Item ID");

        items[item_id] = Stored_item({ // store new item and set it for sale
            item_id: item_id,
            selling_price: price,
            seller: payable(msg.sender),
            available: true
        });
    }

    function buy(uint8 item_id) public payable{
        require(items[item_id].available, "The item you are seeking is not available.");
        require(items[item_id].selling_price <= msg.value, "You don't have enough balance.");

        items[item_id].available = false; // set item as not available
        uint selling_price = items[item_id].selling_price;
        items[item_id].seller.transfer(selling_price); // transfer 

        uint refund = msg.value - selling_price; // refund extra money
        if (refund > 0) {
            address payable buyer = payable(msg.sender);
            buyer.transfer(refund);
        }
    }
}