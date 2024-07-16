// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '@openzeppelin/contracts/utils/Strings.sol';

contract LeaseAgreement {
    enum LeaseState {
        Created,
        Signed,
        Occupied,
        Terminated
    }

    struct Deposit {
        uint sequence;
        uint amount;
    }

    struct Lease {
        address payable landlord;
        address payable tenant;
        string location;
        uint term;
        uint rent;
        uint securityDeposit;
        uint earlyPenalty;
        uint creationTimestamp;
        uint signedTimestamp;
        uint moveinTimestamp;
    }

    //state variables
    LeaseState public state;
    Lease public lease;
    Deposit[] public deposits;

    uint public balance = 0;
    uint public totalReceived = 0;
    uint public securityDeposited = 0;

    event rentPaid(address indexed tenant, uint timestamp);
    event leaseSigned(address indexed tenant, uint timestamp);
    event leaseTerminated(address indexed by, string reason, uint timestamp);
    event securityDepositPaid(
        address indexed tenant,
        uint amount,
        uint timestamp
    );

    constructor(
        uint _rent,
        uint _term,
        uint _securityDeposit,
        uint _earlyPenalty,
        string memory _location
    ) {
        state = LeaseState.Created;
        lease.landlord = payable(msg.sender);
        lease.rent = _rent;
        lease.term = _term;
        lease.securityDeposit = _securityDeposit;
        lease.earlyPenalty = _earlyPenalty;
        lease.location = _location;
        lease.creationTimestamp = block.timestamp;
    }

    modifier inState(LeaseState _state) {
        if (state != _state) revert();
        _;
    }

    modifier onlyLandlord() {
        if (msg.sender != lease.landlord) revert();
        _;
    }

    modifier onlyTenant() {
        if (msg.sender != lease.tenant) revert();
        _;
    }

    modifier payInFull(uint _rent) {
        if (lease.rent != _rent) revert();
        _;
    }

    function signLease() public payable onlyTenant inState(LeaseState.Created) {
        lease.tenant = payable(msg.sender);
        securityDeposited = msg.value;

        require(
            securityDeposited >= lease.securityDeposit,
            string.concat(
                'expected at least ',
                Strings.toString(lease.securityDeposit)
            )
        );

        lease.signedTimestamp = block.timestamp;
        state = LeaseState.Signed;

        emit leaseSigned(lease.tenant, lease.signedTimestamp);
    }

    function moveIn() public onlyTenant inState(LeaseState.Signed) {
        lease.moveinTimestamp = block.timestamp;
        state = LeaseState.Occupied;
    }

    function payRent()
        public
        payable
        onlyTenant
        inState(LeaseState.Occupied)
        payInFull(msg.value + balance)
    {
        totalReceived++;
        balance += msg.value - lease.rent;
        deposits.push(Deposit({sequence: totalReceived, amount: msg.value}));

        lease.landlord.transfer(msg.value);
        emit rentPaid(msg.sender, block.timestamp);
    }

    function leaseDue() public onlyLandlord inState(LeaseState.Occupied) {
        //if lease term is due, return security deposit to the tenant, and the rest to landlord;
        require(totalReceived >= lease.term);

        state = LeaseState.Terminated;
        lease.tenant.transfer(securityDeposited);
        lease.landlord.transfer(address(this).balance);

        emit leaseTerminated(lease.landlord, 'lease due', block.timestamp);
    }

    function evict() public onlyLandlord inState(LeaseState.Occupied) {
        //if missing rent pay, start the eviction; return the balance to the landlord;
        require(totalReceived < lease.term && balance < lease.rent);

        state = LeaseState.Terminated;
        lease.landlord.transfer(address(this).balance);

        emit leaseTerminated(lease.landlord, 'eviction', block.timestamp);
    }

    function terminateEarly()
        public
        payable
        onlyTenant
        inState(LeaseState.Occupied)
    {
        //tenant termintes the lease early, pay penalty; return the balance to landlord
        require(totalReceived < lease.term && msg.value >= lease.earlyPenalty);

        state = LeaseState.Terminated;
        lease.landlord.transfer(address(this).balance);

        emit leaseTerminated(
            lease.tenant,
            'early termination',
            block.timestamp
        );
    }
}
