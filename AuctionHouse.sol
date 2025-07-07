pragma solidity ^0.8.20
Contract AuctionHouse{
error InvalidEndTime(uint256 _endTime);
error InvalidBidAmount(uint256 _amount);
error AuctionEnded(uint256 _blockTime);
error AuctionNotEnded(uint256 _blockTime);
event BidPlaced();

uint156 private auctionEndTime;
mapping(address=>uint256) private bids;
address private currentWinner;

constructor(uint256 _endTime){
if(_endTime<=block.timestamp){
revert InvalidEndTime(_endTime);
}
auctionEndTime=_endTime;
}

function getEndTime() public view returns(uint256){
return auctionEndTime;
}

function getBid() public view returns(uint256){
return bids[msg.sender];
}

function getWinner() public view returns(address _winner, uint256 _amount){
if(auctionEndTime>=block.timestamp){
revert AuctionNotEnded(block.Timestamp);
}
_winner = currentWinner;
_amount = bids[currentWinner];
}

function placeBid(uint256 _amount) public{
if(auctionEndTime<block.timestamp){
revert AuctionEnded(block.timestamp);
}
if(currentWinner!=address(0)&&_amount<=bids[currentWinner]){
revert InvalidBidAmoubt(_amount)
}
bids[msg.sender]=_amount;
currentWinner=msg.sender;
emit BidPlaced();
}
}
