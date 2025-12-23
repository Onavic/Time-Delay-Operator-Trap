// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TimeDelayOperatorTrap.sol";

contract TimeDelayOperatorTrapTest is Test {
    TimeDelayOperatorTrap trap;

    function setUp() public {
        trap = new TimeDelayOperatorTrap();
    }

    function testDecodeCollectPayload() public {
        bytes memory payload = trap.collect();
        (address operator, , ) = abi.decode(
            payload,
            (address, uint256, uint256)
        );

        assertEq(operator, 0xD4D37413680CC2B8C2Ea621993F6A2e226C48a6C);
    }
}
