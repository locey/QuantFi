// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {AirdropToken} from "../../src/airdrop/AirdropToken.sol";
import {AirdropDistributor} from "../../src/airdrop/AirdropDistributor.sol";

contract GetAirdropTokenBanlance is Script {
    function run() external {
        uint256 owner = vm.envUint("TEST_ACCOUNT1_PRIVATE_KEY");
        address ownerAddress = vm.addr(owner);
        vm.startBroadcast(owner);
        address airdropTokenAddress = address(0x4356a7628F97612dd8fAc80b1F8354962D12123C);
        AirdropToken airdropToken = AirdropToken(airdropTokenAddress);
        // proof is the proof of the merkle tree
        // 0xf1997043f7304a54ad086111b8a309c9c3db0c80f250fb1be25e1b1a56e160dc
        uint256 balance = airdropToken.balanceOf(ownerAddress);
        console.log("balance:", balance);

        vm.stopBroadcast();
    }
    
}
