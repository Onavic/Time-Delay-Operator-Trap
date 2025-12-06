// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ActionLog.sol";
import "../src/TimeDelayOperatorTrap.sol";
import "../src/TimeDelayOperatorResponder.sol";

contract DeployTimeDelayTrap is Script {
    function run() external {
        // Load private key from .env
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy ActionLog
        ActionLog actionLog = new ActionLog();
        console.log("ActionLog deployed at:", address(actionLog));

        // 2. Deploy Trap
        TimeDelayOperatorTrap trap = new TimeDelayOperatorTrap(
            address(actionLog)
        );
        console.log("Trap deployed at:", address(trap));

        // 3. Deploy Responder
        TimeDelayOperatorResponder responder = new TimeDelayOperatorResponder(
            address(trap)
        );
        console.log("Responder deployed at:", address(responder));

        vm.stopBroadcast();
    }
}
