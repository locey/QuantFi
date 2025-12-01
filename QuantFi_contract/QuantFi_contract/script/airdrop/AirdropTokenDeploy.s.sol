// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {AirdropToken} from "../../src/airdrop/AirdropToken.sol";
import {AirdropDistributor} from "../../src/airdrop/AirdropDistributor.sol";

contract AirdropTokenDeploy is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("TEST_ACCOUNT1_PRIVATE_KEY");
        vm.startBroadcast(deployerKey);
        AirdropToken token = new AirdropToken("AirdropToken", "ADP", vm.addr(deployerKey));
        // 打印部署的合约地址（方便后续查看）
        console.log("AirdropToken deployed to:", address(token));
        vm.stopBroadcast();
    }
}
