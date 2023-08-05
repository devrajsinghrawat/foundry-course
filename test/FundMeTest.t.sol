// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe, FundMe} from "../script/DeployFundMe.s.sol";
import {Script} from "forge-std/Script.sol";

// import "../src/FundMe.sol";

contract FundMeTest is Test, Script {
    FundMe fundMe;

    uint256 constant MINIMUM_USD = 5e18;

    function setUp() external {
        console.log(" --> FundMeTest :: EoA address : ", msg.sender);
        console.log(" --> FundMeTest :: FundMeTest address : ", address(this));
        DeployFundMe deployer = new DeployFundMe();
        console.log(" --> FundMeTest :: deployer address : ", address(deployer));
        fundMe = deployer.run();
    }

// Checking the https://book.getfoundry.sh/forge/writing-tests // 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84
// But the deployer address remains same as 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38 (which is default for foundry)
//    function testDeployment() public {
//         console.log(" --> FundMeTest :: Deployer EoA address inside Test case : ", msg.sender);
//         console.log(" --> FundMeTest :: FundMeTest address : ", address(this));
//         DeployFundMe deployer = new DeployFundMe();
//         console.log(" --> FundMeTest :: deployer address : ", address(deployer));
//         fundMe = deployer.run();
//         assertEq(address(deployer), 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f);
//     }

    function testMinUSD() public {
        assertEq(fundMe.MINIMUM_USD(), MINIMUM_USD);
    }

    function testOwner() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testGetVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund{value: 0.00001 ether}();
    }

    function testFundSucessWithEnoughEth() public {
        vm.expectEmit();
        fundMe.fund{value: 1 ether}();
    }
}
