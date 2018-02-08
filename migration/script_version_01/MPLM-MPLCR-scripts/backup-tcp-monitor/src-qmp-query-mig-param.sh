echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"query-migrate-parameters\" }" | nc -U ./qmp-sock-9666 
#echo '{ "execute": "quit" }' | nc -U ./qmp-sock-9666 
