
# Learning EOSIO #
## This repo stores scripts that automate the [official development guide of eosio](https://developers.eos.io/eosio-cpp/docs/introduction) ##

### SETUP ###
* git clone ... eos
* edit create-eos-node.sh to use proper folder location 
* add to .bashrc:
```bash
cd eos 
alias cleos='sudo docker exec -it eosio /opt/eosio/bin/cleos --url http://127.0.0.1:7777 --wallet-url http://127.0.0.1:5555'
source eosio-container-vars
```

### USAGE ###
* create a node, setup wallet, and initial dev accounts
> . create-eos-node.sh

Currenly I am struggling with the fact that most probably eosio-cpp does not work correctly when running on a machine with only one processor (? might not be the issue), in any case its related to the os and environment as people report that problem dissapears if no virtual machine is used: https://github.com/EOSIO/eosio.cdt/issues/123





