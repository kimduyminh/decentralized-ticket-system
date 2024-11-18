// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ticket is ERC721 {
    bytes32 private ticketId;

    struct ticketInfo{
        string ticketName;
        uint32 seatPosition;
        uint32 price;
        string positionType;
    }
    mapping(bytes32 => ticketInfo) idToTicketInfo;

    mapping(address => uint256[]) addressToTicketId;

    constructor() ERC721("Ticket", "TCK") {
    }

    //create Tickets
    function _createTickets(string memory _eventName,address _address,uint32 _seatPosition, uint32 _price,string memory _positionType) public{
        ticketId=keccak256(abi.encodePacked(block.timestamp,_address,_seatPosition,_eventName));
        idToTicketInfo[ticketId] = ticketInfo({
            ticketName: _eventName,
            seatPosition: _seatPosition,
            price: _price,
            positionType: _positionType
        });
        _safeMint(_address,uint256(ticketId));
        addressToTicketId[_address].push(uint256(ticketId));
    }
    function _createMultipleTickets(string memory _eventName,address _address, uint32 _numberOfTickets,uint32 _price,string memory _positionType) public{
        for(uint32 i=0;i<_numberOfTickets;i++){
            _createTickets(_eventName, _address, i, _price,_positionType);
        }
    }

    //change Tickets price
    function _changeTicketPrice(bytes32 _ticketId, uint32 _newPrice) public onlyTicketOwner(_ticketId) payable{
        require(msg.value >= 0.002 ether);
        idToTicketInfo[_ticketId].price = _newPrice;
    }

    //get Tickets info
    function _ticketInfo(bytes32 _ticketId) public view returns (ticketInfo memory){
        return idToTicketInfo[_ticketId];
    }
    function _getTicketOwner(bytes32 _ticketId) internal view returns (address){
        return ownerOf(uint256(_ticketId));
    }

    //transfer Tickets
    modifier onlyTicketOwner(bytes32 _ticketId){
        require(msg.sender == _getTicketOwner(_ticketId));
        _;
    }
    function _transferTicket(address _from, address _to, bytes32 _ticketId) public onlyTicketOwner(_ticketId){
        safeTransferFrom(_from, _to, uint256(_ticketId));
        emit Transfer(_from,_to,uint256(_ticketId));
    }
    
    //purchasing Tickets
    function _purchaseTicket(address _address,bytes32 _ticketId) public payable{
        require(msg.value >= idToTicketInfo[_ticketId].price * 1 ether);
        _transferTicket(msg.sender,_address,_ticketId);
    }

}
