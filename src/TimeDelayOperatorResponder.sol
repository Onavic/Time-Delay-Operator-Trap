// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {TimeDelayOperatorTrap} from "./TimeDelayOperatorTrap.sol";

/// @title TimeDelayOperatorResponder
/// @notice Reacts to TimeDelayOperatorTrap alerts
contract TimeDelayOperatorResponder {
    TimeDelayOperatorTrap public trap;

    event Responded(address responder, string message);

    constructor(address _trap) {
        trap = TimeDelayOperatorTrap(_trap);
    }

    /// @notice Check the trap and respond if triggered for a specific operator
    function respond(address operator) external {
        bool triggered = trap.shouldRespond(operator);

        require(triggered, "Trap conditions not met");

        // Example response logic
        emit Responded(msg.sender, "Trap triggered! Responding.");
    }

    /// @notice Helper function to check trap status without responding
    function isTriggered(address operator) external view returns (bool) {
        return trap.shouldRespond(operator);
    }
}
