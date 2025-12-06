// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TimeDelayOperatorTrap.sol";

contract MockActionLog is IActionLog {
    mapping(address => uint256) public lastAction;

    function setLastAction(address operator, uint256 blockNumber) external {
        lastAction[operator] = blockNumber;
    }

    function getLastAction(
        address operator
    ) external view returns (uint256, bytes32) {
        return (
            lastAction[operator],
            keccak256(abi.encodePacked(operator, lastAction[operator]))
        );
    }
}

contract TimeDelayOperatorTrapTest is Test {
    MockActionLog actionLog;
    TimeDelayOperatorTrap trap;

    address operator1 = address(0x1111);
    address operator2 = address(0x2222);

    function setUp() public {
        actionLog = new MockActionLog();
        trap = new TimeDelayOperatorTrap(address(actionLog));
    }

    function testTrapTriggersIfOperatorActsTooSoon() public {
        trap.recordAction(operator1); // operator acts now (block 1)
        vm.roll(block.number + 2); // 2 blocks later

        bool triggered = trap.shouldRespond(operator1);
        assertTrue(triggered, "Trap should fire if operator acts too soon");
    }

    function testTrapDoesNotTriggerIfOperatorWaitedEnough() public {
        trap.recordAction(operator2); // block 1
        vm.roll(block.number + 6); // 6 blocks later

        bool triggered = trap.shouldRespond(operator2);
        assertFalse(
            triggered,
            "Trap should not fire if operator waited enough"
        );
    }
}
