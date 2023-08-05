Setup For Local machine
0 - Start Anvil using command `anvil`
1 - Create .evn using .env.sample 
2 - Set Env in Shell using `source .env` command
3 - Start Explorer ETHERNAL_API_ROOT=$ETHERNAL_API_ROOT ETHERNAL_API_TOKEN=$ETHERNAL_API_TOKEN ethernal listen
4 - Check Data at `https://app.tryethernal.com/`




Imp Commands and Point -
- `forge test` to test the all test cases, 
      - you can use additional -v flag for verbocity, more v you ll add more verbose it will be.
      - We can also add `--fork-url $RPC_FORK` which will execute the test case in that given network rpc context

- `forge coverage` provides the overall execution coverage of the code.

- You ll find that the default EoA for you testing is 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
(You can check this bu consoling console.log(" --> FundMeTest :: EoA address : ", msg.sender) inside your Test Contract. This address is not part of the anvil generated addresses but a defualt address by foundry test enviorment setup).
Ref https://github.com/Cyfrin/foundry-full-course-f23/discussions/211 https://book.getfoundry.sh/reference/config/testing?highlight=0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38#general

- I have also found that the default test contract addresses is 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496 (Not only for me but for others as well)
Ref:- https://ethereum.stackexchange.com/questions/144991/why-is-my-foundry-test-contract-not-deploying-to-the-0xb4c79dab8f259c7aee6e5b2aa


ToDo 
- Mock the Price Feed contract setup for local test case exeuction
- Write a fund test case
  - Test emit event test


Done 
- Run the local chain Anvil
  anvil on CLI after foundryup command  
- Watch the Local Chain on state change
  ETHERNAL_API_ROOT=https://api.tryethernal.com ETHERNAL_API_TOKEN=xxxx ethernal listen
- Run a local explorer
  https://app.tryethernal.com/

- Set Env in Shell

- Helper scrip for Default network selection
