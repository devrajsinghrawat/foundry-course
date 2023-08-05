Setup For Local machine
0 - Start Anvil using command `anvil`
1 - Create .evn using .env.sample 
2 - Set Env in Shell using `source .env` command
3 - Start Explorer ETHERNAL_API_ROOT=$ETHERNAL_API_ROOT ETHERNAL_API_TOKEN=$ETHERNAL_API_TOKEN ethernal listen
4 - Check Data at `https://app.tryethernal.com/`



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
