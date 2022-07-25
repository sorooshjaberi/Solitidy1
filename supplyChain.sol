// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
contract dealer{

    enum productState {created,paid,delivered}

    mapping (uint => Product) public items;

    event step(uint _itemIndex, uint state);

    uint index;
    struct Product {
        productState state;
        string productName ;
        uint priceInWei;
        address buyer;
    }
    function add() view  public returns(address){
        return msg.sender;
    }
    function createProduct(string memory _name, uint _priceInWei) public {
        items[index].productName = _name;
        items[index].priceInWei = _priceInWei;
        items[index].state = productState.created;
        emit step(index,uint(items[index].state));
        index++;
    }
    function payProduct(uint _index) payable public{
        require(items[_index].priceInWei <= msg.value, "Not fully paid");
        require(items[_index].state==productState.created, "we don't have it yet");
        items[_index].state = productState.paid;
        items[_index].buyer = msg.sender;
        emit step(_index,uint(items[_index].state));
    }

    function deliveredProduct(uint _index) public{
        require(items[_index].state==productState.created, "we don't have it yet");
        require(items[_index].buyer==msg.sender, "you didn't bought this");
        items[index].state = productState.delivered;
        emit step(_index,uint(items[_index].state));

    }
}