echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"disable-max-migration-rate-limit\" }" | nc -U ./qmp-sock-9666 
#echo '{ "execute": "quit" }' | nc -U ./qmp-sock-9666 
