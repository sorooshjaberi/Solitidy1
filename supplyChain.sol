// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Ownable {
    address owner;

    constructor(){
        owner=msg.sender;
    }
    function isOwner() public view returns(bool){
        return msg.sender ==owner;
    }
    modifier onlyOwner(){
        require(isOwner(),"onlyOwner");
        _;
    }


}

contract item{

    uint priceInWei;
    uint pricePaid;
    uint index;
    itemManager parentContract;

    constructor(uint _priceInWei, uint _index, itemManager _parentContract){
    priceInWei=_priceInWei;
    index=_index;
    parentContract=_parentContract;
    }
    receive() external payable{
        require(priceInWei==msg.value,"pay completeley");
        require(pricePaid == 0,"item is already paid");
        pricePaid+=msg.value;
       (bool status,)=address(parentContract).call{value:msg.value}(abi.encodeWithSignature("payProduct(uint)",index));
       require(status,"something went wrong, canceling the transaction");
    }
    fallback()external{}
}



contract itemManager is Ownable{

    enum productState {created,paid,delivered}

    mapping (uint => Product) public items;

    event step(uint _itemIndex, uint state, address itemContract);

    uint index;
    struct Product {
        
        productState state;
        string productName ;
        uint priceInWei;
        address buyer;
        item item;
    }
    function add() view  public returns(address){
        return msg.sender;
    }
    function createProduct(string memory _name, uint _priceInWei) public onlyOwner{
        item ItemContract = new item(_priceInWei, index,this);
        items[index].productName = _name;
        items[index].priceInWei = _priceInWei;
        items[index].state = productState.created;
        items[index].item= ItemContract;
        emit step(index,uint(items[index].state), address(items[index].item));
        index++;
    }
    function payProduct(uint _index) payable public{
        require(items[_index].priceInWei <= msg.value, "Not fully paid");
        require(items[_index].state==productState.created, "we don't have it yet");
        items[_index].state = productState.paid;
        items[_index].buyer = msg.sender;
        emit step(_index,uint(items[_index].state),address(items[index].item));
    }

    function deliveredProduct(uint _index) public{
        require(items[_index].state==productState.created, "we don't have it yet");
        require(items[_index].buyer==msg.sender, "you didn't bought this");
        items[index].state = productState.delivered;
        emit step(_index,uint(items[_index].state),address(items[index].item));

    }
}