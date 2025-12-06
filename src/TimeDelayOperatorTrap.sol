// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IActionLog {
    function getLastAction(
        address operator
    ) external view returns (uint256, bytes32);
}

contract TimeDelayOperatorTrap {
    IActionLog public actionLog;
    uint256 public blockDelay = 5; // N blocks

    mapping(address => uint256) public lastActionBlock;

    constructor(address _actionLog) {
        actionLog = IActionLog(_actionLog);
    }

    function recordAction(address operator) external {
        lastActionBlock[operator] = block.number;
    }

    function shouldRespond(address operator) external view returns (bool) {
        uint256 lastBlock = lastActionBlock[operator];
        if (block.number < lastBlock + blockDelay) {
            return true; // trigger trap
        }
        return false; // safe
    }
}
