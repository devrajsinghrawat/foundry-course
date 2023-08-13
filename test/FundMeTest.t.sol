// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe, FundMe} from "../script/DeployFundMe.s.sol";
import {Script} from "forge-std/Script.sol";
import {IFundMe} from "./../Interfaces/IFundMe.sol";

/** 
  --> FundMeTest :: EoA address :  0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
  --> FundMeTest :: FundMeTest address :  0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
  --> FundMeTest :: deployer address :  0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f                <MIGHT CHANGE>
  --> HelperConfig :: mock address :  0x90193C961A926261B756D1E5bb255e67ff9498A1                  <MIGHT CHANGE>
  --> DeployFundMe :: helperConfig address :  0x104fBc016F4bb334D775a19E8A6510109AC63E00          <MIGHT CHANGE>
  --> DeployFundMe :: fundMe address :  0xA8452Ec99ce0C64f20701dB7dD3abDb607c00496                <MIGHT CHANGE>
*/

contract FundMeTest is Test, Script, IFundMe {
    FundMe fundMe;

    address Tester = makeAddr("testuser");

    uint256 constant MINIMUM_USD = 5e18;
    uint256 constant SEND_VALUE = 1 ether; // 1000000000000000000 .i.e 1e18
    uint256 constant INITIAL_BALANCE = 10 ether; // 1000000000000000000 .i.e 1e18
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        deal(Tester, INITIAL_BALANCE);
        console.log(" --> FundMeTest :: EoA address : ", msg.sender);
        console.log(" --> FundMeTest :: FundMeTest address : ", address(this));
        DeployFundMe deployer = new DeployFundMe();
        console.log(
            " --> FundMeTest :: deployer address : ",
            address(deployer)
        );
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
        // Fund method SHOULD received funds value of:  1000000000000000000 (1 ETH)
        // from: 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496 (.i.e. address(this)).
        vm.expectEmit();
        emit IFundMe.FUNDED(address(this), SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();
    }

    modifier funded() {
        vm.prank(Tester);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testFunderBalance() public funded {
        assertEq(fundMe.getAddressToAmount(Tester), SEND_VALUE);
    }

    function testGetFunders() public funded {
        address[] memory funders = fundMe.getFunders();
        console.log("Funders --> : ", funders[0]);
        assertTrue(funders.length > 0);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(Tester);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testOwnerCanWithdrawSingleFunder() public funded {
        // Arrange
        uint256 ownerStartingBalance = fundMe.i_owner().balance;
        console.log("ownerStartingBalance : ", ownerStartingBalance);
        uint256 fundContractStatringBalance = address(fundMe).balance;
        console.log("fundContractStatringBalance : ", fundContractStatringBalance);

        // Act
        uint256 startGas = gasleft();
        console.log("Start Gas :", startGas);
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();
        uint256 endGas = gasleft();
        console.log("End Gas :", endGas);
        console.log("Gas Used :", startGas - endGas);

        // Assert
        uint256 ownerClosingBalance = fundMe.i_owner().balance;
        console.log("ownerClosingBalance : ", ownerClosingBalance);
        uint256 fundContractClosingBalance = address(fundMe).balance;
        console.log("fundContractClosingBalance : ", fundContractClosingBalance);

        assertEq(fundContractClosingBalance, 0);
        assertEq(ownerClosingBalance, (ownerStartingBalance + fundContractStatringBalance));
    } 

    function testOwnerCanWithdrawMultiFunder() public {
        // Arrange
        uint160 startintIndex = 1;
        uint160 numberOfFunders = 11;
        for (uint160 i = startintIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);      // Act as prank + deal together 
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 ownerStartingBalance = fundMe.i_owner().balance;
        console.log("ownerStartingBalance : ", ownerStartingBalance);
        uint256 fundMeContractStatringBalance = address(fundMe).balance;
        console.log("fundContractStatringBalance : ", fundMeContractStatringBalance);

        // Act
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();

        // Assert
        uint256 ownerClosingBalance = fundMe.i_owner().balance;
        console.log("ownerClosingBalance : ", ownerClosingBalance);
        uint256 fundMeContractClosingBalance = address(fundMe).balance;
        console.log("fundContractClosingBalance : ", fundMeContractClosingBalance);

        assertEq(fundMeContractClosingBalance, 0);
        assertEq(ownerClosingBalance, (ownerStartingBalance + fundMeContractStatringBalance));
    }        
}
