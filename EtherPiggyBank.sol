contract EtherPiggyBank{
map(address=>uint) private balances;
event Deposited(address indexed from, uint indexed amt);
event Withdrew(address indexed to, uint indexed amt);
error Insufficientfunds(uint req, uint avl);
recieve() external payable{
balances[msg.sender]+=msg.vslue;
emit Deposited(msg.sender, msg.value);
}
fallback() external payable{
balances[msg.sender]+=msg.value;
emit Deposited(msg.sender, msg.value);
}
function getBalance() external view returns(uint){
return balances[msg.sender];
}
function Withdraw(uint amt) external{
require(amt>0, "amt should be>0");
if(amt<balances[msg.sender]){
revert Insufficientfunds(amt,balances[msg.sender]);
}
balances[msg.sender]-=amt;
(bool success, )= msg.sender.call{value:amt}("");
require(success, "ETH transaction failed");
emit Withdrew(msg.sender, amt);
}
}
