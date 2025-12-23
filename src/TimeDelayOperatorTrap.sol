// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IActionLog {
    function getLastActionBlock(
        address operator
    ) external view returns (uint256);
}

/// @title TimeDelayOperatorTrap (Drosera-native)
contract TimeDelayOperatorTrap {
    /// -----------------------------------------------------------------------
    /// HARD-CODED CONFIG (required by Drosera)
    /// -----------------------------------------------------------------------

    // Operator this trap monitors (one trap per operator)
    address public constant OPERATOR =
        0xD4D37413680CC2B8C2Ea621993F6A2e226C48a6C;

    // Minimum blocks required between actions
    uint256 public constant MIN_BLOCK_DELAY = 5;

    // Deployed ActionLog (read-only)
    address public constant ACTION_LOG =
        0xf738Dddc0EFca5ad17a5B5EA83b9c3d613f4ea13;

    /// -----------------------------------------------------------------------
    /// Drosera interface
    /// -----------------------------------------------------------------------

    /// @notice Collect read-only data for Drosera sampling
    function collect() external view returns (bytes memory) {
        uint256 lastActionBlock = IActionLog(ACTION_LOG).getLastActionBlock(
            OPERATOR
        );

        return abi.encode(OPERATOR, lastActionBlock, block.number);
    }

    /// @notice Decide whether responder should fire
    function shouldRespond(
        bytes[] calldata data
    ) external pure returns (bool, bytes memory) {
        (address operator, uint256 lastActionBlock, uint256 currentBlock) = abi
            .decode(data[0], (address, uint256, uint256));

        if (lastActionBlock == 0) {
            return (false, bytes(""));
        }

        if (currentBlock < lastActionBlock + MIN_BLOCK_DELAY) {
            return (true, abi.encode(operator));
        }

        return (false, bytes(""));
    }
}
