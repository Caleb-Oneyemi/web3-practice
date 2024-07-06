// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
contract GroupWallet {
    address public manager;
    mapping(address => Benficiary) public beneficiaries;

    struct Benficiary {
        address beneficiary;
        uint allowance;
        uint validity;
    }

    modifier onlyManger() {
        manager == msg.sender;
        _;
    }

    event AllowanceRenewed(
        address indexed beneficiary,
        uint validity,
        uint timeLimit
    );
    event CoinsSpent(address indexed receiver, uint amount);

    constructor() {
        manager = msg.sender;
    }

    /** fund contract */
    receive() external payable onlyManger {}

    function getWalletBalance() public view returns (uint) {
        return address(this).balance;
    }

    function myAllowance() public view returns (uint) {
        return beneficiaries[msg.sender].allowance;
    }

    /** timeLimit in seconds */
    function renewAllowance(
        address _beneficiary,
        uint _allowance,
        uint _timeLimit
    ) public onlyManger {
        uint _validity = block.timestamp + _timeLimit;

        beneficiaries[_beneficiary] = Benficiary({
            beneficiary: _beneficiary,
            allowance: _allowance,
            validity: _validity
        });

        emit AllowanceRenewed(_beneficiary, _allowance, _timeLimit);
    }

    function spendCoins(address payable _receiver, uint _amount) public {
        Benficiary storage beneficiary = beneficiaries[msg.sender];

        require(block.timestamp < beneficiary.validity, 'validity expired!!!');
        require(_amount <= beneficiary.allowance, 'insufficient funds!!!');

        beneficiary.allowance -= _amount;
        _receiver.transfer(_amount);

        emit CoinsSpent(_receiver, _amount);
    }
}
