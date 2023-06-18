// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/Counters.sol";

contract ZkHacker {
    receive() external payable {}

    fallback() external payable {}

    using Counters for Counters.Counter;

    Counters.Counter private _projectIdCounter;

    function getCurrentProfileId() public view returns (uint256) {
        return _projectIdCounter.current();
    }

    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    struct Project {
        uint256 id;
        address owner;
        string description;
        bool explore;
        bool voting;
        bool blacklist;
        uint256 similarityScore;
        uint256 upVotes;
        uint256 downVotes;
    }
    Project[] public projects;

    mapping(address => Project) public projectByUser;

    mapping(uint256 => Project) public projectById;

    // Register Project
    function addProject(
        string memory _description,
        bool _explore,
        bool _voting,
        bool _blacklist,
        uint256 _similarityScore
    ) public {
        uint256 _id = getCurrentProfileId();

        Project memory project = Project(_id, msg.sender, _description, _explore, _voting, _blacklist, _similarityScore, 0, 0);
        projects.push(project);

        projectById[_id] = project;
        projectByUser[msg.sender] = project;

        _projectIdCounter.increment();
    }

    // Voting
    function upVoteProject(uint256 _id) public {
        projectById[_id].upVotes++;
    }

    function downVoteProject(uint256 _id) public {
        projectById[_id].downVotes++;
    }

    function getExploreProjects() public view returns (Project[] memory) {
        uint totalItemCount = 0;
        for (uint256 i = 0; i < projects.length; i ++) {
            if (projectById[i].explore) {
                totalItemCount ++;
            }
        }

        uint currentIndex = 0;

        Project[] memory items = new Project[](totalItemCount);

        for (uint i = 0; i < projects.length; i++) {
            if (projectById[i].explore) {
                items[currentIndex] = projectById[i];
                currentIndex++;
            }
        }

        return items;
    }

    function getVotingProjects() public view returns (Project[] memory) {
        uint totalItemCount = 0;
        for (uint256 i = 0; i < projects.length; i ++) {
            if (projectById[i].voting) {
                totalItemCount ++;
            }
        }

        uint currentIndex = 0;

        Project[] memory items = new Project[](totalItemCount);

        for (uint i = 0; i < projects.length; i++) {
            if (projectById[i].voting) {
                items[currentIndex] = projectById[i];
                currentIndex++;
            }
        }

        return items;
    }

    function getBlacklistProjects() public view returns (Project[] memory) {
        uint totalItemCount = 0;
        for (uint256 i = 0; i < projects.length; i ++) {
            if (projectById[i].blacklist) {
                totalItemCount ++;
            }
        }

        uint currentIndex = 0;

        Project[] memory items = new Project[](totalItemCount);

        for (uint i = 0; i < projects.length; i++) {
            if (projectById[i].blacklist) {
                items[currentIndex] = projectById[i];
                currentIndex++;
            }
        }

        return items;
    }

    function getProjectbyId(uint256 _id) public view returns(Project memory) {
        return projectById[_id];
    }
}
