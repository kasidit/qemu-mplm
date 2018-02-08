echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"live-checkpointing-disable\" }" | nc -U ./qmp-sock-9666 
#echo '{ "execute": "quit" }' | nc -U ./qmp-sock-9666 
