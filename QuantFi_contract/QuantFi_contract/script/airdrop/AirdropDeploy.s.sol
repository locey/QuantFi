// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {AirdropToken} from "../../src/airdrop/AirdropToken.sol";
import {AirdropDistributor} from "../../src/airdrop/AirdropDistributor.sol";

contract AirdropDeploy is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("TEST_ACCOUNT1_PRIVATE_KEY");
        vm.startBroadcast(deployerKey);
        // AirdropToken token = AirdropToken(0x4356a7628F97612dd8fAc80b1F8354962D12123C);
        AirdropDistributor distributor = new AirdropDistributor(address(0x4356a7628F97612dd8fAc80b1F8354962D12123C), vm.addr(deployerKey));
        // 打印部署的合约地址（方便后续查看）
        console.log("AirdropDistributor deployed to:", address(distributor));
        // token.mint(address(distributor), 1_000_000 ether);
        vm.stopBroadcast();
    }
}
