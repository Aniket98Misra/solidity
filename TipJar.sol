// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract TipJar {
    address public owner;
    uint private totalTip;
    mapping(string => uint) public exchangeRates;
    event ConversionRateChanged(string indexed currency, uint oldRate, uint newRate);
    event NewTip(address indexed sender, uint amount);
    error NotAllowed();
    error CurrencyNotAllowed();
    constructor() {
        owner = msg.sender;
        exchangeRates["USD"] = 51000;
        exchangeRates["EUR"] = 53000;
        exchangeRates["INR"] = 600;
    }
    modifier ownerOnly() {
        if (msg.sender != owner) {
            revert NotAllowed();
        }
        _;
    }
    function getTotalTip() external view ownerOnly returns (uint) {
        return totalTip;
    }
    function setExchangeRate(string memory _currency, uint _rate) external ownerOnly {
        uint oldRate = exchangeRates[_currency];
        exchangeRates[_currency] = _rate;
        emit ConversionRateChanged(_currency, oldRate, _rate);
    }
    function tip(uint _amount, string memory _currency) external {
        require (_amount > 0, "amount must be greater than 0.");
        if (exchangeRates[_currency] == 0) {
            revert CurrencyNotAllowed();
        }
        uint weiAmount = _amount * exchangeRates[_currency];
        totalTip += weiAmount;
        emit NewTip(msg.sender, weiAmount);
    
}
