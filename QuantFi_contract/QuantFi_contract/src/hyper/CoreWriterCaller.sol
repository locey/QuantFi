// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./CoreWriter.sol";
import "openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts/contracts/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract TradingContract {
    using SafeERC20 for IERC20;

    CoreWriter public coreWriter;

    constructor() {
        coreWriter = CoreWriter(0x3333333333333333333333333333333333333333);
        // __Ownable_init(_owner);
    }

    // function initialize(address _owner) public initializer {
    //     __Ownable_init(_owner);
    //     //__UUPSUpgradeable_init();
    //     coreWriter = CoreWriter(0x3333333333333333333333333333333333333333);
    // }

    // function _authorizeUpgrade(
    //     address newImplementation
    // ) internal override onlyOwner {}

    function placeLimitOrder(
        uint32 asset,
        bool isBuy,
        uint64 limitPx,
        uint64 sz,
        bool reduceOnly,
        uint8 encodedTif,
        uint128 cloid
    ) external {
        // 构造动作编码
        bytes memory encodedAction = abi.encode(
            asset,
            isBuy,
            limitPx,
            sz,
            reduceOnly,
            encodedTif,
            cloid
        );

        // 构造完整数据
        bytes memory data = new bytes(4 + encodedAction.length);
        data[0] = 0x01; // 编码版本
        data[1] = 0x00; // 动作ID - 限价单
        data[2] = 0x00;
        data[3] = 0x01;

        // 复制动作数据
        for (uint256 i = 0; i < encodedAction.length; i++) {
            data[4 + i] = encodedAction[i];
        }

        // 调用 CoreWriter 合约
        coreWriter.sendRawAction(data);
    }

    function sendUsdClassTransfer(uint64 ntl, bool toPerp) external {
        bytes memory encodedAction = abi.encode(ntl, toPerp);
        bytes memory data = new bytes(4 + encodedAction.length);
        data[0] = 0x01;
        data[1] = 0x00;
        data[2] = 0x00;
        data[3] = 0x07; // USD转账动作ID

        for (uint256 i = 0; i < encodedAction.length; i++) {
            data[4 + i] = encodedAction[i];
        }

        coreWriter.sendRawAction(data);
    }

    function sendAsset(
        address destination,
        address subAccount,
        uint32 source_dex,
        uint32 destination_dex,
        uint64 token,
        uint64 w
    ) external {
        bytes memory encodedAction = abi.encode(
            destination,
            subAccount,
            source_dex,
            destination_dex,
            token,
            w
        );
        bytes memory data = new bytes(4 + encodedAction.length);
        data[0] = 0x01;
        data[1] = 0x00;
        data[2] = 0x00;
        data[3] = 0x0d; // 发送资产

        for (uint256 i = 0; i < encodedAction.length; i++) {
            data[4 + i] = encodedAction[i];
        }

        coreWriter.sendRawAction(data);
    }
}
