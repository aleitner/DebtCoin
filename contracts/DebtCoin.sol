pragma solidity ^0.4.13;

import './SafeMath.sol';
import './Ownable.sol';

/**
 * @title DebtCoin
 * @dev Really cool C
 */
contract DebtCoin is Ownable {
    using SafeMath for uint256;

    event Payment(address indexed _debtor, uint256 _amount);
    event DebtAccumulated(address indexed _debtor, uint256 _amount);

    mapping(address => uint256) debts;

    string public name;
    string public symbol;
    uint256 public decimals;

    /**
    * @dev Contructor that gives msg.sender all of existing tokens.
    */
    function DebtCoin() public {
        name = "Debt Coin";
        symbol = "DTC";
        decimals = 18;
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
    * @dev Adds debt to address
    * @param _debtor The address acquiring debt
    * @param _debtor The amount of debt being acquired
    */
    function accumulateDebt(address _debtor, uint256 _debt) public onlyOwner {
        if (_debtor == 0x0) revert();
        if (balances[_debtor].add(_debt) < balances[_debtor]) revert(); // Check for overflows
        balances[_debtor] = balances[_debtor].add(_debt);

        DebtAccumulated(_debtor, _debt);
    }

    /**
    * @dev Adds debt to address
    * @param _debtor The address acquiring debt
    * @param _debtor The amount of debt being acquired
    */
    function makePayment() public payable returns (uint256 amount) {
        amount = msg.value

        require(debts[msg.sender] >= amount);

        /* pay off debt */
        balances[msg.sender] -= amount;

        DebtAccumulated(msg.sender, amount);

        return amount;
    }

    /**
    * @dev Amount of ether to withdraw from contract in wei
    * @return amount uint256 Amount of ether in wei
    */
    function withdrawEther(uint256 _wei) public onlyOwner {
        require(msg.sender.send(_wei));
    }

}
