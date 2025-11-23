// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {CoreWriterLib} from "@hyper-evm-lib/src/CoreWriterLib.sol";
import {HLConversions} from "@hyper-evm-lib/src/common/HLConversions.sol";
import {PrecompileLib} from "@hyper-evm-lib/src/PrecompileLib.sol";

contract CoreWriterCallerByLib {
    /// @notice Bridges tokens to core and then sends them to another address
    function bridgeToCoreAndSend(
        uint64 tokenId,
        uint256 evmAmount,
        address recipient
    ) external payable {
        // use CoreWriterLib to bridge tokens
        CoreWriterLib.bridgeToCore(tokenId, evmAmount);

        // Convert EVM amount to wei amount (used in HyperCore)
        uint64 coreAmount = HLConversions.evmToWei(tokenId, evmAmount);

        // use CoreWriterLib to call the spotSend CoreWriter action
        CoreWriterLib.spotSend(recipient, tokenId, coreAmount);
    }

    /**
     * @notice Bridges tokens to core and then sends them to another address
     */
    function bridgeToCoreAndSendByTokenAddress(
        address tokenAddress,
        uint256 evmAmount,
        address recipient
    ) external payable {
        // Get token ID from address
        uint64 tokenId = PrecompileLib.getTokenIndex(tokenAddress);

        // Bridge tokens to core
        CoreWriterLib.bridgeToCore(tokenAddress, evmAmount);

        // Convert EVM amount to core amount
        uint64 coreAmount = HLConversions.evmToWei(tokenId, evmAmount);

        // Send tokens to recipient on core
        CoreWriterLib.spotSend(recipient, tokenId, coreAmount);
    }

    function bridgeToCoreAndSendHype(
        uint256 evmAmount,
        address recipient
    ) external payable {
        // Bridge tokens to core
        CoreWriterLib.bridgeToCore(HLConstants.hypeTokenIndex(), evmAmount);

        // Convert EVM amount to core amount
        uint64 coreAmount = HLConversions.evmToWei(
            HLConstants.hypeTokenIndex(),
            evmAmount
        );

        // Send tokens to recipient on core
        CoreWriterLib.spotSend(
            recipient,
            HLConstants.hypeTokenIndex(),
            coreAmount
        );
    }
}
