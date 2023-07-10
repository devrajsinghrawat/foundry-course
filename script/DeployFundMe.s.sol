// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() public returns (FundMe) {
        // Before Broadcast - not a real tx
        HelperConfig helperConfig = new HelperConfig();
        console.log("Deployed Helper address", address(helperConfig));
        (address ethUsdPriceFeed) = helperConfig.currentNetworkConfig();
        console.log("Helper ethUsdPriceFeed address", ethUsdPriceFeed);

        
        // After Broadcast - Real tx
        vm.startBroadcast();
        // Mock
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
