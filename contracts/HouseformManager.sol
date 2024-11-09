// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./HouseFormShare.sol";

contract HouseformManager is Ownable, ReentrancyGuard {
    struct Project {
        uint projectId;
        address builder;
        uint currentAmount;
        uint goalAmount;
        uint saleAmount;
        uint expectedProfit;
        uint builderFee;
        uint currentShares;
        uint totalShares;
        uint fundraisingDeadline;
        uint fundraisingCompletedOn;
        uint buildingStartedOn;
        uint buildingCompletedOn;
    }

    HouseformShare public shareContract;
    Project[] public projects;
    mapping(address => uint[]) public builderToProjects;
    mapping(uint => bool) public projectToFeeRedeemed;

    event ProjectCreated(
        uint _projectId,
        string _name,
        string _description,
        string _image,
        uint _goalAmount,
        uint _expectedProfit,
        uint _builderFee,
        uint _totalShares,
        uint _fundraisingDeadline
    );
    event BuildingStarted(uint _projectId, uint _buildingStartedOn);
    event BuildingCompleted(uint _projectId, uint _buildingCompletedOn, uint _saleAmount);
    event SharesBought(address _account, uint _projectId, uint _shares);
    event SharesRedeemed(address _account, uint _projectId, uint _shares);
    event FeeRedeemed(address _account, uint _projectId, uint _amountRedeemed);
    event FundraisingCompleted(uint _projectId, uint _fundraisingCompletedOn);

    constructor() Ownable(msg.sender) {
        shareContract = new HouseformShare();
    }

    // Rest of the contract remains exactly the same...
    modifier projectExists(uint _projectId) {
        require(_projectId >= 0 && _projectId < projects.length, "Project does not exist");
        _;
    }

    modifier onlyBuilder(uint _projectId) {
        require(projects[_projectId].builder == msg.sender, "Caller is not the project builder");
        _;
    }

    modifier fundraisingNotExpired(uint _projectId) {
        require(block.timestamp <= projects[_projectId].fundraisingDeadline, "Fundraising expired");
        _;
    }

    modifier fundraisingExpired(uint _projectId) {
        require(block.timestamp > projects[_projectId].fundraisingDeadline, "Fundraising not expired yet");
        _;
    }

    modifier fundraisingNotCompleted(uint _projectId) {
        require(projects[_projectId].fundraisingCompletedOn == 0, "Fundraising already completed");
        _;
    }

    modifier fundraisingCompleted(uint _projectId) {
        require(projects[_projectId].fundraisingCompletedOn != 0, "Fundraising not completed");
        _;
    }

    modifier buildingNotStarted(uint _projectId) {
        require(projects[_projectId].buildingStartedOn == 0, "Building already started");
        _;
    }

    modifier buildingStarted(uint _projectId) {
        require(projects[_projectId].buildingStartedOn != 0, "Building not started");
        _;
    }

    modifier buildingNotCompleted(uint _projectId) {
        require(projects[_projectId].buildingCompletedOn == 0, "Building already completed");
        _;
    }

    modifier buildingCompleted(uint _projectId) {
        require(projects[_projectId].buildingCompletedOn != 0, "Building not completed");
        _;
    }

    function createProject(
        string memory _name,
        string memory _description,
        string memory _image,
        uint _goalAmount,
        uint _expectedProfit,
        uint _builderFee,
        uint _totalShares,
        uint _fundraisingDeadline
    ) external nonReentrant {
        require(_goalAmount > 0, "Invalid goal amount");
        require(_builderFee >= 0 && _builderFee < 100, "Invalid builder fee");
        require(_totalShares > 1, "Invalid total shares");
        require(_expectedProfit >= 0, "Invalid expected profit");
        require(_fundraisingDeadline >= block.timestamp + 1 days, "Invalid fundraising deadline");
uint id = projects.length;

        projects.push(
            Project({
                projectId: id,
                builder: msg.sender,
                currentAmount: 0,
                goalAmount: _goalAmount,
                saleAmount: 0,
                expectedProfit: _expectedProfit,
                builderFee: _builderFee,
                currentShares: 0,
                totalShares: _totalShares,
                fundraisingDeadline: _fundraisingDeadline,
                fundraisingCompletedOn: 0,
                buildingStartedOn: 0,
                buildingCompletedOn: 0
            })
        );

        builderToProjects[msg.sender].push(id);
        shareContract.setMetadata(id, _name, _description, _image);

        emit ProjectCreated(
            id,
            _name,
            _description,
            _image,
            _goalAmount,
            _expectedProfit,
            _builderFee,
            _totalShares,
            _fundraisingDeadline
        );
    }

    function startBuilding(uint _projectId)
        external
        projectExists(_projectId)
        onlyBuilder(_projectId)
        fundraisingCompleted(_projectId)
        buildingNotStarted(_projectId)
        nonReentrant
    {
        Project storage project = projects[_projectId];

        (bool success, ) = project.builder.call{value: project.currentAmount}("");
        require(success, "Failed to send amount");

        project.buildingStartedOn = block.timestamp;
        project.currentAmount = 0;

        emit BuildingStarted(_projectId, project.buildingStartedOn);
    }

    function completeBuilding(uint _projectId)
        external
        payable
        projectExists(_projectId)
        onlyBuilder(_projectId)
        buildingStarted(_projectId)
        buildingNotCompleted(_projectId)
        nonReentrant
    {
        Project storage project = projects[_projectId];

        require(msg.value > 0, "Invalid sale amount");

        project.buildingCompletedOn = block.timestamp;
        project.currentAmount = msg.value;
        project.saleAmount = msg.value;

        emit BuildingCompleted(_projectId, project.buildingCompletedOn, project.saleAmount);
    }

    function buyShares(uint _projectId, uint _shares)
        external
        payable
        projectExists(_projectId)
        fundraisingNotExpired(_projectId)
        fundraisingNotCompleted(_projectId)
        nonReentrant
    {
        Project storage project = projects[_projectId];

        require(_shares > 0 && _shares <= project.totalShares - project.currentShares, "Invalid shares count");

        uint _sharesAmount = _shares * getShareCost(_projectId);
        require(msg.value == _sharesAmount, "Incorrect shares amount");

        project.currentShares += _shares;
        project.currentAmount += _sharesAmount;

        shareContract.mint(msg.sender, _projectId, _shares, "");

        emit SharesBought(msg.sender, _projectId, _shares);

        if (project.currentShares == project.totalShares && project.currentAmount == project.goalAmount) {
            project.fundraisingCompletedOn = block.timestamp;
            emit FundraisingCompleted(_projectId, project.fundraisingCompletedOn);
        }
    }

    function redeemFee(uint _projectId)
        external
        projectExists(_projectId)
        onlyBuilder(_projectId)
        buildingCompleted(_projectId)
        nonReentrant
    {
        Project storage project = projects[_projectId];

        require(!projectToFeeRedeemed[_projectId], "Builder fee already redeemed");
        require(project.saleAmount - project.goalAmount > 0, "No profit no party");

        uint amountToRedeem = ((project.saleAmount - project.goalAmount) * project.builderFee) / 100;
        require(amountToRedeem <= project.currentAmount, "Invalid amount to redeem");

        (bool success, ) = msg.sender.call{value: amountToRedeem}("");
        require(success, "Failed to send amount");

        project.currentAmount -= amountToRedeem;
        projectToFeeRedeemed[_projectId] = true;
emit FeeRedeemed(msg.sender, _projectId, amountToRedeem);
    }

    function redeemShares(uint _projectId, uint _shares)
        external
        projectExists(_projectId)
        buildingCompleted(_projectId)
        nonReentrant
    {
        Project storage project = projects[_projectId];

        uint investorShares = shareContract.balanceOf(msg.sender, _projectId);
        require(_shares > 0 && _shares <= investorShares, "Invalid shares count");

        uint amountToRedeem = _shares * getShareValue(_projectId);
        require(amountToRedeem <= project.currentAmount, "Invalid amount to redeem");

        shareContract.burn(msg.sender, _projectId, _shares);
        (bool success, ) = payable(msg.sender).call{value: amountToRedeem}("");
        require(success, "Failed to send amount");

        project.currentAmount -= amountToRedeem;

        emit SharesRedeemed(msg.sender, _projectId, _shares);
    }

    function getProjects() external view returns (Project[] memory) {
        Project[] memory projectsArray = new Project[](projects.length);
        for (uint i = 0; i < projects.length; i++) {
            projectsArray[i] = projects[i];
        }
        return projectsArray;
    }

    function getBuilderProjects(address _builder) external view returns (Project[] memory) {
        Project[] memory projectsArray = new Project[](builderToProjects[_builder].length);
        for (uint i = 0; i < builderToProjects[_builder].length; i++) {
            projectsArray[i] = projects[builderToProjects[_builder][i]];
        }
        return projectsArray;
    }

    function getProjectsCount() external view returns (uint) {
        return projects.length;
    }

    function getBuilderProjectsCount(address _builder) external view returns (uint) {
        return builderToProjects[_builder].length;
    }

    function getProject(uint _projectId) external view returns (Project memory) {
        Project memory project = projects[_projectId];
        return project;
    }

    function getShareCost(uint _projectId) public view returns (uint) {
        Project memory project = projects[_projectId];
        return project.goalAmount / project.totalShares;
    }

    function getShareValue(uint _projectId) public view returns (uint) {
        Project memory project = projects[_projectId];

        if (project.saleAmount == 0) {
            return project.goalAmount / project.totalShares;
        }

        if (project.saleAmount - project.goalAmount > 0) {
            uint builderFeeAmount = ((project.saleAmount - project.goalAmount) * project.builderFee) / 100;
            return (project.saleAmount - builderFeeAmount) / project.totalShares;
        } else {
            return project.saleAmount / project.totalShares;
        }
    }
}