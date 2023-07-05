// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundme;

    uint256 constant MINIMUM_USD = 5e18;

    function setUp() external {
        fundme = new FundMe();
    }

    function testMinUSD() public {
        assertEq(fundme.MINIMUM_USD(), MINIMUM_USD);
    }

    function testOwner() public {
        assertEq(fundme.i_owner(), address(this));
    }
}
