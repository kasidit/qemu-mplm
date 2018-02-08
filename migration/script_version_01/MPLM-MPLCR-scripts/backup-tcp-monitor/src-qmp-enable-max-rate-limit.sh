echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"enable-max-migration-rate-limit\" }" | nc -U ./qmp-sock-9666 
#echo '{ "execute": "quit" }' | nc -U ./qmp-sock-9666 
