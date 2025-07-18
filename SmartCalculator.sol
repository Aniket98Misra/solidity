// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Calculator {
   
    address private owner;

  
    error NotOwner();
    constructo(){
    owner=msg.sender;
    }
  
    modifier ownerOnly {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    
    function add(int a, int b) external view ownerOnly returns (int) {
        return a + b;
    }

    
    function subtract(int a, int b) external view ownerOnly returns (int) {
        return a - b;
    }

  
    function multiply(int a, int b) external view ownerOnly returns (int) {
        return a * b;
    }

  
    function divide(int a, int b) external view ownerOnly returns (int) {
        return a / b;
    }


    function remainder(int a, int b) external view ownerOnly returns (int) {
        return a % b;
    }
}
contract SmartCalculator {
    Calculator private calculator;

    
    error InvalidOperator(bytes8 operator);

  
    bytes8 public constant ADD = "+";
    bytes8 public constant SUBTRACT = "-";
    bytes8 public constant MULTIPLY = "*";
    bytes8 public constant DIVIDE = "/";
    bytes8 public constant REMAINDER = "%";
    constructo(){
    calculator= new Calculator();
    }
function calculate(bytes8 operator, int a, int b) external view returns (int) {
        if (operator == ADD) {
            return calculator.add(a, b);

        } else if (operator == SUBTRACT) {
            return calculator.subtract(a, b);

        } else if (operator == MULTIPLY) {
            return calculator.multiply(a, b);

        } else if (operator == DIVIDE) {
            return calculator.divide(a, b);

        } else if (operator == REMAINDER) {
            return calculator.remainder(a, b);

        } else {
            revert InvalidOperator(operator);
        }
    }
}
