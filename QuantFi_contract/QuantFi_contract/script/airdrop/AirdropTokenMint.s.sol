// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {AirdropToken} from "../../src/airdrop/AirdropToken.sol";
import {AirdropDistributor} from "../../src/airdrop/AirdropDistributor.sol";

contract AirdropTokenMint is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("TEST_ACCOUNT1_PRIVATE_KEY");
        vm.startBroadcast(deployerKey);
        AirdropToken token = AirdropToken(0x4356a7628F97612dd8fAc80b1F8354962D12123C);
        token.mint(address(0x37C5e4DDA006adE159BFD603fc125Bf2c7e73743), 1_000_000 ether);
        vm.stopBroadcast();
    }
}
