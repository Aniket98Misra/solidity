contract AdminOnly {
    error NotAllowed(address user);
    error InsufficientQuantity(string item, uint256 requested, uint256 available);
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event TreasureDeposited(string indexed item, uint256 indexed quantity);
    event TreasureWithdrawn(address indexed user, string indexed item, uint256 indexed quantity);
    address public owner;
    mapping(string => uint256) public treasures;
    mapping(address => bool) private approvals;
    construct(){
    owner=msg.sender;
    }
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotAllowed(msg.sender);
        }
        _;
    }
    modifier onlyApproved() {
        if (msg.sender != owner && !approvals[msg.sender]) {
            revert NotAllowed(msg.sender);
        }
        _;
    }
     function setOwner(address newOwner) external onlyOwner {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnerChanged(oldOwner, newOwner);
    }
    function approveWithdrawal(address user) external onlyOwner {
        approvals[user] = true;
    }
    function revokeApproval(address user) external onlyOwner {
        approvals[user] = false;
    }
    function depositTreasure(string calldata item, uint256 quantity) external onlyOwner {
        require(quantity > 0, "Quantity must be greater than 0");
        treasures[item] += quantity;
        emit TreasureDeposited(item, quantity);
    }
    function withdrawTreasure(string calldata item, uint256 quantity) external onlyApproved {
        require(quantity > 0, "Quantity must be greater than 0");
        uint256 available = treasures[item];
        if (quantity > available) {
            revert InsufficientQuantity(item, quantity, available);
        }
        approvals[msg.sender] = false;
        treasures[item] -= quantity;
        emit TreasureWithdrawn(msg.sender, item, quantity);
    }
}
