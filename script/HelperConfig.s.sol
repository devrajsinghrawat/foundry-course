// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console } from "forge-std/Script.sol";
import { MockV3Aggregator } from "../test/mocks/MockV3Aggregator.sol";

// Deploy mock Price feed contract or other dependent contracts, when we are on local chain
// Keep track of contract addresses across chains
contract HelperConfig is Script {

uint256 constant MAINNET = 1;
uint256 constant SEPOLIA = 11155111;
uint256 constant ANVIL = 31337;

struct NetworkConfig {
    address priceFeed;      //ETH-USD Pricefeed address
}

NetworkConfig public currentNetworkConfig;

constructor() {
    console.log("block.chainid --> ", block.chainid);

    // https://data.chain.link/ethereum/mainnet/crypto-usd/eth-usd
    if (block.chainid == MAINNET) { 
        // console.log("I m Here in getMainnetEthConfig --> ");
        currentNetworkConfig = getMainnetEthConfig();
    }
    else if (block.chainid == SEPOLIA) {
        // console.log("I m Here in getSepoliaEthConfig --> ");
        currentNetworkConfig = getSepoliaEthConfig();
    } 
    else if (block.chainid == ANVIL){
        // console.log("I m Here in getAnvilEthConfig --> ");
        currentNetworkConfig = getAnvilEthConfig();
    }
    // console.log("currentNetworkConfig after exit --> ", currentNetworkConfig.priceFeed);
}

function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory config = NetworkConfig({priceFeed 
    : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
    return config;
}

function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory config = NetworkConfig({priceFeed 
    : 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    return config;
}

function getAnvilEthConfig() public returns (NetworkConfig memory) {
    // Check if the config exist

    // If not then deploy mock contract for price feed
    vm.startBroadcast();
    // Deploy the mock 
    MockV3Aggregator mock = new MockV3Aggregator(8, 2000);
    vm.stopBroadcast();

    NetworkConfig memory config = NetworkConfig({priceFeed 
    : address(mock)});
    return config;
}

}