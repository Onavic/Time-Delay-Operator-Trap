// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ActionLog.sol";
import "../src/TimeDelayOperatorTrap.sol";
import "../src/TimeDelayOperatorResponder.sol";

contract DeployTimeDelayTrap is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        ActionLog actionLog = new ActionLog();
        TimeDelayOperatorTrap trap = new TimeDelayOperatorTrap();
        TimeDelayOperatorResponder responder = new TimeDelayOperatorResponder();

        vm.stopBroadcast();
    }
}
