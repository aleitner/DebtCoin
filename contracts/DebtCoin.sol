pragma solidity ^0.4.13;

import './SafeMath.sol';
import './Ownable.sol';

/**
 * @title DebtCoin
 * @dev Really cool C
 */
contract DebtCoin is Ownable {
    using SafeMath for uint256;

    event Payment(address indexed _debtor, address indexed _creditor, uint256 _amount);
    event DebtAccumulated(address indexed _debtor, uint256 _amount);

    mapping(address => uint256) debts;

    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalDebts;

    /**
    * @dev Contructor that gives msg.sender all of existing tokens.
    */
    function DebtCoin() public {
        name = "Debt Coin";
        symbol = "DTC";
        decimals = 0;
    }

    /**
    * @dev Gets the debt of the specified address.
    * @param _debtor The address to query the debt of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function debtOf(address _debtor) public view returns (uint256 balance) {
        return debts[_debtor];
    }

    /**
    * @dev Amount of ether to withdraw from contract in wei
    * @return amount uint256 Amount of ether in wei
    */
    function withdrawEther(uint256 _wei) public onlyOwner {
        require(msg.sender.send(_wei));
    }

}
