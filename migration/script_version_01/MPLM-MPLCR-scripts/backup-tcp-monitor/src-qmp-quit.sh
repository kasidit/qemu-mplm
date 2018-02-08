echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"quit\" }" | nc -U ./qmp-sock-9666 
#echo '{ "execute": "quit" }' | nc -U ./qmp-sock-9666 
