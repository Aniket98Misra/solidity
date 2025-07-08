contract PollStation{
struct Candidate{
string name;
uint64 voteCount;
}

error CandidateIndexInvalid(uint _index);
error AlreadyVoted(address _user);
error NotVoted(address _user);
event Voted(address indexed _user, uint indexed _candidateIndex);

Candidate[] private candidates;
mapping(address=>uint) private userVotes;
//constructor9
candidates.push(Candidate("Alice", 0));
candidates.push(Candidate("Bob", 0));
candidates.push(Candidate("Charlie", 0));
}
function getCandidatesCount() public view returns(uint){
return candidates.Length;
}
function getCandidate(uint _index) public view returns(string memory name, uint64 voteCount){
if(_index>=candidates.Length){
revert CandidateIndexInvalid(_index);
}
name=candidates[_index].name;
votecount=candidates[_index].voteCount;
}
function getVote() public view returns(uint){
if(userVotes[msg.sender]==0){
revert NotVoted[msg.sender];
}
return userVotes[msg.sender]-1;
}
function maxVotes() public view returns(uint _index, uint64 _votes){
for(uint i=0;i<candidates.Length;i++){
if(candidates[i].voteCount>_votes){
_index=i;
_votes=candidates[i].voteCount;
}
}
}
function vote(uint _index) public{
if(|_index>=candidates.Length){
revert CandidateIndexInvalid(-index);
}
if(userVotes[msg.sender]!=0){
revert AlreadyVoted[msg.sender];
}
userVotes[msg.sender]=-index|+1;
candidates[_index].voteCount+=1;
emit Voted(msg.sender,_index);
}
}
