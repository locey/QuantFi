// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {AirdropToken} from "../../src/airdrop/AirdropToken.sol";
import {AirdropDistributor} from "../../src/airdrop/AirdropDistributor.sol";

contract ClaimAirdropToken is Script {
    function run() external {
        uint256 owner = vm.envUint("TEST_ACCOUNT1_PRIVATE_KEY");
        vm.startBroadcast(owner);
        AirdropDistributor distributor = AirdropDistributor(0x37C5e4DDA006adE159BFD603fc125Bf2c7e73743);
        // proof is the proof of the merkle tree
        // 0xf1997043f7304a54ad086111b8a309c9c3db0c80f250fb1be25e1b1a56e160dc
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = 0xaf9c50f4bb5c77b0be0fcd00a6536cd385ecd2c44356bd828c2eea67b089420c;
        distributor.claim(12, 400 ether, proof);
        // (bytes32 merkleRoot, uint64 claimDeadline, bool active) = distributor.rounds(10);
        // console.logBytes32(merkleRoot);
        // console.log("claimDeadline:", uint256(claimDeadline));
        // console.log("active:", active);

        vm.stopBroadcast();
    }
    
}
