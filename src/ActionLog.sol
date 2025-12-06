// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ActionLog {
    mapping(address => uint256) public lastAction;
    mapping(address => bytes32) public lastActionHash;

    function logAction(address operator, bytes32 actionHash) external {
        lastAction[operator] = block.number;
        lastActionHash[operator] = actionHash;
    }

    function getLastAction(
        address operator
    ) external view returns (uint256, bytes32) {
        return (lastAction[operator], lastActionHash[operator]);
    }
}
