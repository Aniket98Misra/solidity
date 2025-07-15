contract SimpleIOU {
    mapping (address => uint) private balances;
    mapping (address => mapping (address => uint)) private lentAmounts;
    event Deposited(address indexed from, uint indexed amount);
    event Withdrew(address indexed to, uint indexed amount);
    event Lent(address indexed lender, address indexed borrower, uint indexed amount);
    event Repaid(address indexed borrower, address indexed lender, uint indexed amount);
    error InsufficientFunds(uint requested, uint available);
    error ExcessRepayment(address lender, uint amount, uint borrowed);
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
    fallback() external payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
    function getBalance() external view returns (uint) {
        return balances[msg.sender];
    }
    function getLentAmount(address _borrower) external view returns (uint) {
        return lentAmounts[msg.sender][_borrower];
    }
    function getBorrowedAmount(address _lender) external view returns (uint) {
        return lentAmounts[_lender][msg.sender];
    }
    function withdraw(uint amount) external {
        require(amount > 0, "amount must be greater than 0");
        if (amount > balances[msg.sender]) {
            revert InsufficientFunds(amount, balances[msg.sender]);
        }
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "ETH transfer failed");
        emit Withdrew(msg.sender, amount);
    }
    function lend(address _borrower, uint amount) external {
        require(amount > 0, "amount must be greater than 0");
        if (amount > balances[msg.sender]) {
            revert InsufficientFunds(amount, balances[msg.sender]);
        }
        balances[msg.sender] -= amount;
        balances[_borrower] += amount;
        lentAmounts[msg.sender][_borrower] += amount;
        emit Lent(msg.sender, _borrower, amount);
    }
    function repay(address _lender, uint amount) external {
        require(amount > 0, "amount must be greater than 0");
        if (amount > balances[msg.sender]) {
            revert InsufficientFunds(amount, balances[msg.sender]);
        }
        if (amount > lentAmounts[_lender][msg.sender]) {
            revert ExcessRepayment(_lender, amount, lentAmounts[_lender][msg.sender]);
        }
        balances[msg.sender] -= amount;
        balances[_lender] += amount;
        lentAmounts[_lender][msg.sender] -= amount;
        emit Repaid(msg.sender, _lender, amount);
    }
}
