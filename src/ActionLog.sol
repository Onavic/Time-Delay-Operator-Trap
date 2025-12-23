// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ActionLog
/// @notice Canonical on-chain record of operator actions
contract ActionLog {
    mapping(address => uint256) private lastActionBlock;

    function logAction(address operator) external {
        lastActionBlock[operator] = block.number;
    }

    function getLastActionBlock(
        address operator
    ) external view returns (uint256) {
        return lastActionBlock[operator];
    }
}
