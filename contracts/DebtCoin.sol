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
    * @param _debtor address The address to query the debt of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function debtOf(address _debtor) public view returns (uint256 balance) {
        return debts[_debtor];
    }

    /**
    * @dev Adds debt to address
    * @param _debtor address The address acquiring debt
    * @param _debt The amount of debt being acquired
    */
    function accumulateDebt(address _debtor, uint256 _debt) public onlyOwner {
        if (_debtor == 0x0) revert();
        if (debts[_debtor].add(_debt) < debts[_debtor]) revert(); // Check for overflows
        debts[_debtor] = debts[_debtor].add(_debt);

        DebtAccumulated(_debtor, _debt);
    }

    /**
    * @dev Pay for debt
    */
    function makePayment() public payable returns (uint256 amount) {
        amount = msg.value;

        require(debts[msg.sender] >= amount);

        /* pay off debt */
        debts[msg.sender] -= amount;

        DebtAccumulated(msg.sender, amount);

        return amount;
    }

    /**
    * @dev Relieve debt for address
    * @param _debtor address The address with debt
    * @param _amount The amount of debt being relieved
    */
    function relieveDebt(address _debtor, uint256 _amount) public onlyOwner {
        if (_debtor == 0x0) revert();
        if (debts[_debtor].sub(_amount) > debts[_debtor]) revert(); // Check for overflows
        debts[_debtor] = debts[_debtor].sub(_amount);

        Payment(_debtor, _amount);
    }


    /**
    * @dev Amount of ether to withdraw from contract in wei
    * @return amount uint256 Amount of ether in wei
    */
    function withdrawEther(uint256 _wei) public onlyOwner {
        require(msg.sender.send(_wei));
    }

}
