// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ticket is ERC721 {
    bytes32 private ticketId;
    array address public eventOrganizer[];

    struct ticketInfo{
        string ticketName;
        uint256 seatPosition;
        uint256 price;
        string positionType;
    }
    mapping(bytes32 => ticketInfo) idToTicketInfo;

    mapping(address => uint256[]) addressToTicketId;

    constructor() ERC721("Ticket", "TCK") {
    }

    //minting Tickets
    function _createTickets(string memory _eventName,address _address,uint256 _seatPosition, uint256 _price,string memory _positionType) public onlyOrganizer(_address){
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
    function _createMultipleTickets(string memory _eventName,address _address,uint256 _numberOfTickets,uint256 _price,string memory _positionType) public onlyOrganizer(_address){
        for(uint256 i=0;i<_numberOfTickets;i++){
            _createTickets(_eventName, _address, i, _price,_positionType);
        }
    }

    //change Tickets price
    function _changeTicketPrice(bytes32 _ticketId, uint256 _newPrice) public onlyTicketOwner(_ticketId) payable{
        require(idToTicketInfo.contains(_ticketId));
        require(msg.value >= 0.002 ether);
        require(_newPrice > 0);
        require(_newPrice != idToTicketInfo[_ticketId].price);
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

    //event organizer 
    modifier onlyOrganizer(address _address){
        require(eventOrganizer.contains(_address));
        _;
    }
    fun _addEventOrganizer(address _address) public onlyOwner{
        eventOrganizer.push(_address);
    }
    fun _removeEventOrganizer(address _address) public onlyOwner{
        eventOrganizer.remove(_address);
    }


}
