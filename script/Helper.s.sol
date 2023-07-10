// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/FundMe.sol";

contract Helper is Script {

uint256 constant MAINNET = 1;
uint256 constant SEPOLIA = 111155111;

struct NetworkInfo {
    uint256 chainId;
    string rpc;
}

NetworkInfo defualtSetNetwork;

// function getChain() public returns (NetworkInfo memory) {
//     // if (block.chainid == MAINNET) {
//     //     defualtSetNetwork.chainId = MAINNET;
//     //     defualtSetNetwork.rpc = 
//     // } else (block.chainid == SEPOLIA) {
//     //     defualtSetNetwork.chainId = SEPOLIA;
//     // }
//     return defualtSetNetwork;
// }

}