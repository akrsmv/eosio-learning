 # !/ usr /bin/env sh
#!/bin/bash

#sudo docker pull eosio/eos:v1.4.2

export EOS_CHAIN_PRIVATE_KEY=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

sudo docker run --name eosio --publish 7777:7777 --publish 127.0.0.1:5555:5555 --volume /root/eos/contracts:/root/eos/contracts --detach eosio/eos:v1.4.2 /bin/bash -c "keosd --http-server-address=0.0.0.0:5555 & exec nodeos -e -p eosio --plugin eosio::producer_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data --config-dir /mnt/dev/config --http-server-address=0.0.0.0:7777 --access-control-allow-origin=* --contracts-console --http-validate-host=false --filter-on='*'"

# run keosd with proper port forwarding
sudo docker exec -it eosio bash -c 'cleos --wallet-url http://127.0.0.1:5555 wallet list && exit'

# create a development wallet
alias cleos='sudo docker exec -it eosio /opt/eosio/bin/cleos --url http://127.0.0.1:7777 --wallet-url http://127.0.0.1:5555'

# CREATE DEFAULT WALLET, STORE ITS PASSWD IN A FILE
cleos wallet create --to-console > ./TMP_WALLET_CREATE_OUTPUT
export WALLET_PWD=`cat TMP_WALLET_CREATE_OUTPUT | grep -o '"[a-zA-Z0-9]*"' | grep -o -E  [a-zA-Z0-9] | paste -sd ''`
echo $WALLET_PWD > ./eosio-default-wallet-password
cleos wallet open
cleos wallet unlock --password $WALLET_PWD
echo THIS WALLET PWD IS $WALLET_PWD and is stored in file eosio-default-wallet-password

# CREATE IMPORT AND STORE A WALLET KEY
cleos wallet create_key > ./TMP_WALLET_CREATE_KEY_OUTPUT
export WALLET_KEY=`cat TMP_WALLET_CREATE_KEY_OUTPUT | grep -o '"[a-zA-Z0-9]*"' | grep -o -E  [a-zA-Z0-9] | paste -sd ''`
cleos wallet import --private-key $EOS_CHAIN_PRIVATE_KEY
echo $WALLET_KEY > ./eosio-default-wallet-key
echo THIS WALLET KEY IS $WALLET_KEY and is stored in file eosio-default-wallet-key

sleep 5

# CREATE TEST ACCOUNTS
cleos create account eosio bob $WALLET_KEY
cleos create account eosio alice $WALLET_KEY

rm TMP_WALLET_CREATE_OUTPUT
rm TMP_WALLET_CREATE_KEY_OUTPUT

echo 'export WALLET_PWD='$WALLET_PWD > ./eosio-container-vars
echo 'export WALLET_KEY='$WALLET_KEY >> ./eosio-container-vars

