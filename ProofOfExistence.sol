//SPDX-Lincense-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract ProofOfExistence {
    struct EmployeeRecord {
        uint256 ID;
        string fullname;
        string gender;
        uint256 age;
        string department;
        uint256 salary;
    }

    uint256 ID = 1000;
    address boss;

    mapping(address => uint256) private employeeToID;
    mapping(uint256 => EmployeeRecord) internal IDToRecord;
    mapping(uint256 => EmployeeRecord) public resignation;

    EmployeeRecord[] employeesRecord;

    constructor(address _boss) {
        boss = _boss;
    }

    modifier onlyBoss() {
        require(msg.sender == boss, "Only the Boss can add a new employee");
        _;
    }

    function addEmployee(
        address _address,
        string memory _fullname,
        string memory _gender,
        uint256 _age,
        string memory _department,
        uint256 _salary
    ) public onlyBoss returns (bool, uint256) {
        if (addressExist(_address)) {
            return (false, employeeToID[_address]);
        }
        ID = ID + 1;

        EmployeeRecord memory newEmployee = EmployeeRecord(
            ID,
            _fullname,
            _gender,
            _age,
            _department,
            _salary
        );

        employeesRecord.push(newEmployee);

        employeeToID[_address] = ID;

        IDToRecord[ID] = newEmployee;

        return (true, ID);
    }

    function retriveID() external view returns (bool, uint256) {
        uint256 id = employeeToID[msg.sender];
        if (id == 0) return (false, 0);
        return (true, id);
    }

    function bossRecovery(address _address)
        external
        view
        onlyBoss
        returns (bool, uint256)
    {
        uint256 id = employeeToID[_address];
        if (id == 0) return (false, 0);
        return (true, id);
    }

    function confirmRecord(uint256 _ID)
        external
        view
        returns (EmployeeRecord memory)
    {
        return IDToRecord[_ID];
    }

    function addressExist(address _address) internal view returns (bool) {
        return !(employeeToID[_address] == 0);
    }

    function resigned(uint256 IDTobeDeleted) external onlyBoss returns (bool) {
        require(IDToRecord[IDTobeDeleted].ID != 0, "Employee have resigned");
        resignation[IDTobeDeleted] = IDToRecord[IDTobeDeleted];
        delete IDToRecord[IDTobeDeleted];

        uint256 indexTobeRemoved;
        for (uint256 i; i < employeesRecord.length; i++) {
            if (employeesRecord[i].ID == IDTobeDeleted) {
                indexTobeRemoved = i;
                break;
            }
        }
        employeesRecord[indexTobeRemoved] = employeesRecord[
            employeesRecord.length - 1
        ];
        employeesRecord.pop();

        return true;
    }
}
